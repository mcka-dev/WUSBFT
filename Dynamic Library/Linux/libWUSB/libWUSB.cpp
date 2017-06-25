#include "libWUSB.h"
#include "ftd2xx.h"

#define CRC_Init 0xDE //CRC Initial value

FT_HANDLE ftHandle;   //device handle
FT_STATUS ftStatus;   //device status

const unsigned char
FEND = 0xC0,          //Frame END
FESC = 0xDB,          //Frame ESCape
TFEND = 0xDC,         //Transposed Frame END
TFESC = 0xDD;         //Transposed Frame ESCape

void DowCRC(unsigned char b, unsigned char &crc);
bool RxByte(unsigned char &b);

//----------------------- Access check for USB resource: --------------------

EXTERN_HEADER bool AccessUSB(int DevNum)
{
	FT_HANDLE ftHandle_t;
	FT_STATUS ftStatus_t;

	ftStatus_t = FT_Open(DevNum, &ftHandle_t);
	if (!FT_SUCCESS(ftStatus_t)) {
		return false;
	}
	else {
		FT_Close(ftHandle_t);
		return true;
	}
}

//------------------------ Get number of USB devices: -----------------------

EXTERN_HEADER bool NumUSB(unsigned int &numDevs)
{
	FT_STATUS ftStatus_t;

	ftStatus_t = FT_ListDevices(&numDevs, NULL, FT_LIST_NUMBER_ONLY);
	return FT_SUCCESS(ftStatus_t);
}

//----------------------------- Open USB ------------------------------------

EXTERN_HEADER bool OpenUSB(int DevNum, unsigned int baud)
{
	ftStatus = FT_Open(DevNum, &ftHandle);
	if (!FT_SUCCESS(ftStatus)) { //device open error
		return false;
	}

	ftStatus = FT_SetLatencyTimer(ftHandle, 1);
	if (!FT_SUCCESS(ftStatus)) { //set latency error
		return false;
	}

	ftStatus = FT_SetBaudRate(ftHandle, baud);
	if (!FT_SUCCESS(ftStatus)) { //set baud error
		return false;
	}

	ftStatus = FT_SetDataCharacteristics(ftHandle,
		FT_BITS_8, FT_STOP_BITS_1, FT_PARITY_NONE);
	if (!FT_SUCCESS(ftStatus)) { //set mode error
		return false;
	}

	ftStatus = FT_SetTimeouts(ftHandle, 1000, 1000);
	if (!FT_SUCCESS(ftStatus)) { //set timeouts error
		return false;
	}

	ftStatus = FT_Purge(ftHandle, FT_PURGE_RX | FT_PURGE_TX);
	if (!FT_SUCCESS(ftStatus)) { //purge error
		return false;
	}

	return true;
}


//------------------------------ Close USB: ---------------------------------

EXTERN_HEADER bool CloseUSB(void)
{
	ftStatus = FT_Close(ftHandle);
	return FT_SUCCESS(ftStatus);
}

//------------- Purge USB: terminates TX and RX and clears buffers: ---------

EXTERN_HEADER bool PurgeUSB(void)
{
	ftStatus = FT_Purge(ftHandle, FT_PURGE_RX | FT_PURGE_TX);
	return FT_SUCCESS(ftStatus);
}

//---------------------------------------------------------------------------

void  DowCRC(unsigned char b, unsigned char &crc)
{
	for (int i = 0; i < 8; i++)
	{
		if (((b ^ crc) & 1) != 0) {
			crc = ((crc ^ 0x18) >> 1) | 0x80;
		}
		else {
			crc = (crc >> 1) & ~0x80;
		}
		b = b >> 1;
	}
}

//---------------------------------------------------------------------------

bool RxByte(unsigned char &b)
{
	DWORD r;

	ftStatus = FT_Read(ftHandle, &b, 1, &r);
	if (!FT_SUCCESS(ftStatus)) {
		return false;
	}

	if (r != 1) {
		return false;
	}

	return true;
}

//--------------------------- Receive frame: --------------------------------

EXTERN_HEADER bool RxFrameUSB(unsigned int To, unsigned char &ADD, unsigned char &CMD,
	unsigned char &N, unsigned char *Data)
{
	int i;

	unsigned char b = 0, crc = CRC_Init; //init CRC
	ftStatus = FT_SetTimeouts(ftHandle, To, 1000);
	if (!FT_SUCCESS(ftStatus)) { //set timeouts error
		return false;
	}
	for (i = 0; i < 512 && b != FEND; i++) {
		if (!RxByte(b)) { //frame synchronzation
			break;
		}
	}
	if (b != FEND) { //timeout or sync error
		return false;
	}
	DowCRC(b, crc); //update CRC
	N = 0; ADD = 0;
	for (i = -3; i <= N; i++)
	{
		if (!RxByte(b)) { //timeout error
			break;
		}
		if (b == FESC) {
			if (!RxByte(b)) { //timeout error
				break;
			}
			else {
				if (b == TFEND) { //TFEND <- FEND
					b = FEND;
				}
				else {
					if (b == TFESC) { //TFESC <- FESC
						b = FESC;
					}
					else {
						break;
					}
				}
			}
		}
		if (i == -3) {
			if ((b & 0x80) == 0) { //CMD (b.7=0)
				CMD = b;
				i++;
			}
			else { //ADD (b.7=1)
				b = b & 0x7F;
				ADD = b;
			}
		}
		else {
			if (i == -2) {
				if ((b & 0x80) != 0) { //CMD error (b.7=1)
					break;
				}
				else { //CMD
					CMD = b;
				}
			}
			else {
				if (i == -1) { //N
					N = b;
				}
				else {
					if (i != N) { //data
						Data[i] = b;
					}
				}
			}
		}
		DowCRC(b, crc); //update CRC
	}
	return ((i == N + 1) && !crc); //RX or CRC error
}

//--------------------------- Transmit frame: -------------------------------

EXTERN_HEADER bool TxFrameUSB(unsigned char ADDR, unsigned char CMD, unsigned char N,
	unsigned char *Data)
{
	unsigned char Buff[518];
	DWORD r, j = 0;
	unsigned char d, crc = CRC_Init; //init CRC

	for (int i = -4; i <= N; i++)
	{
		if ((i == -3) && (!ADDR)) {
			i++;
		}
		if (i == -4) { //FEND 
			d = FEND;
		}
		else {
			if (i == -3) { //address
				d = ADDR & 0x7F;
			}
			else {
				if (i == -2) { //command
					d = CMD & 0x7F;
				}
				else {
					if (i == -1) { //N
						d = N;
					}
					else {
						if (i == N) { //CRC
							d = crc;
						}
						else //data      
						{
							d = Data[i];
						}
					}
				}
			}
		}
		DowCRC(d, crc);
		if (i == -3) {
			d = d | 0x80;
		}
		if (i > -4) {
			if ((d == FEND) || (d == FESC))
			{
				Buff[j++] = FESC;

				if (d == FEND) {
					d = TFEND;
				}
				else {
					d = TFESC;
				}
			}
		}
		Buff[j++] = d;
	}

	ftStatus = FT_Write(ftHandle, Buff, j, &r);
	if (!FT_SUCCESS(ftStatus)) {
		return false;
	}

	if (r != j) {
		return false;
	}

	return true;
}
