#include <windows.h>
#define WUSB_Exports
#include "wusb.h"
#include "Ftd2xx.h"

// #pragma argsused

#define CRC_Init 0xDE     //CRC Initial value

FT_HANDLE ftHandle;       //device handle
FT_STATUS ftStatus;       //device status

const unsigned char
FEND = 0xC0,            //Frame END
FESC = 0xDB,            //Frame ESCape
TFEND = 0xDC,            //Transposed Frame END
TFESC = 0xDD;            //Transposed Frame ESCape

void __fastcall DowCRC(unsigned char b, unsigned char &crc);
bool __fastcall RxByte(unsigned char &b);


BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}



//---------------------------------------------------------------------------
/*
int DllEntryPoint(HINSTANCE hinst, unsigned long reason, void* lpReserved)
{
return 1;
}
*/
//----------------------- Access check for USB resource: --------------------

bool WINAPI AccessUSB(int DevNum)
{
	FT_HANDLE ftHandle_t;

	FT_STATUS ftStatus_t;

	ftStatus_t = FT_Open(DevNum, &ftHandle_t);
	if (!FT_SUCCESS(ftStatus_t))  return false;
	else { FT_Close(ftHandle_t); return true; }
}

//------------------------ Get number of USB devices: -----------------------

bool WINAPI NumUSB(DWORD &numDevs)
{
	FT_STATUS ftStatus_t;


	ftStatus_t = FT_ListDevices(&numDevs, NULL, FT_LIST_NUMBER_ONLY);
	if (!FT_SUCCESS(ftStatus_t))  return false;
	return true;
}

//----------------------------- Open USB ------------------------------------

bool WINAPI OpenUSB(int DevNum, DWORD baud)
{
	ftStatus = FT_Open(DevNum, &ftHandle);
	if (!FT_SUCCESS(ftStatus)) return false;  //device open error
	ftStatus = FT_SetLatencyTimer(ftHandle, 1);
	if (!FT_SUCCESS(ftStatus)) return false;  //set latency error
	ftStatus = FT_SetBaudRate(ftHandle, baud);
	if (!FT_SUCCESS(ftStatus)) return false;  //set baud error
	ftStatus = FT_SetDataCharacteristics(ftHandle,
		FT_BITS_8, FT_STOP_BITS_1, FT_PARITY_NONE);
	if (!FT_SUCCESS(ftStatus)) return false;  //set mode error
	ftStatus = FT_SetTimeouts(ftHandle, 1000, 1000);
	if (!FT_SUCCESS(ftStatus)) return false;  //set timeouts error
	ftStatus = FT_Purge(ftHandle, FT_PURGE_RX | FT_PURGE_TX);
	if (!FT_SUCCESS(ftStatus)) return false;  //purge error
	return true;
}

//------------------------------ Close USB: ---------------------------------

bool WINAPI CloseUSB(void)
{
	ftStatus = FT_Close(ftHandle);
	if (!FT_SUCCESS(ftStatus)) return false;
	return true;
}

//------------- Purge USB: terminates TX and RX and clears buffers: ---------

bool WINAPI PurgeUSB(void)
{
	ftStatus = FT_Purge(ftHandle, FT_PURGE_RX | FT_PURGE_TX);
	if (!FT_SUCCESS(ftStatus)) return false;
	return true;
}

//---------------------------------------------------------------------------

void __fastcall DowCRC(unsigned char b, unsigned char &crc)
{
	for (int i = 0; i < 8; i++)

	{
		if (((b ^ crc) & 1) != 0)
			crc = ((crc ^ 0x18) >> 1) | 0x80;
		else crc = (crc >> 1) & ~0x80;
		b = b >> 1;
	}
}

//---------------------------------------------------------------------------

bool __fastcall RxByte(unsigned char &b)
{
	DWORD r;
	//	bool x;


	ftStatus = FT_Read(ftHandle, &b, 1, &r);
	if (!FT_SUCCESS(ftStatus)) return false;
	if (r != 1) return false;
	return true;
}

//--------------------------- Receive frame: --------------------------------

bool WINAPI RxFrameUSB(DWORD To, unsigned char &ADD, unsigned char &CMD,
	unsigned char &N, unsigned char *Data)
{
	int i;

	unsigned char b = 0, crc = CRC_Init;           //init CRC
	ftStatus = FT_SetTimeouts(ftHandle, To, 1000);
	if (!FT_SUCCESS(ftStatus)) return false;     //set timeouts error
	for (i = 0; i < 512 && b != FEND; i++)
		if (!RxByte(b))     break;                    //frame synchronzation
	if (b != FEND) return false;                   //timeout or sync error
	DowCRC(b, crc);                                //update CRC
	N = 0; ADD = 0;
	for (i = -3; i <= N; i++)
	{
		if (!RxByte(b))    break;                    //timeout error
		if (b == FESC)
			if (!RxByte(b))   break;                    //timeout error
			else
			{
				if (b == TFEND) b = FEND;              //TFEND <- FEND

				else
					if (b == TFESC) b = FESC;              //TFESC <- FESC
					else break;
			}
		if (i == -3)
			if ((b & 0x80) == 0) { CMD = b; i++; }     //CMD (b.7=0)
			else { b = b & 0x7F; ADD = b; }           //ADD (b.7=1)
		else
			if (i == -2)
				if ((b & 0x80) != 0) break;                //CMD error (b.7=1)
				else CMD = b;                             //CMD
			else
				if (i == -1)
					N = b;                                     //N
				else
					if (i != N) Data[i] = b;                   //data
		DowCRC(b, crc);                             //update CRC
	}
	return ((i == N + 1) && !crc);                    //RX or CRC error
}

//--------------------------- Transmit frame: -------------------------------

bool WINAPI TxFrameUSB(unsigned char ADDR, unsigned char CMD, unsigned char N,
	unsigned char *Data)
{
	unsigned char Buff[518]; DWORD r, j = 0;

	unsigned char d, crc = CRC_Init;              //init CRC

	for (int i = -4; i <= N; i++)
	{
		if ((i == -3) && (!ADDR)) i++;
		if (i == -4) d = FEND;        else          //FEND
			if (i == -3) d = ADDR & 0x7F; else          //address
				if (i == -2) d = CMD & 0x7F; else          //command
					if (i == -1) d = N;           else          //N
						if (i == N) d = crc;         else          //CRC
							d = Data[i];                   //data
		DowCRC(d, crc);
		if (i == -3) d = d | 0x80;
		if (i > -4)
			if ((d == FEND) || (d == FESC))
			{
				Buff[j++] = FESC;

				if (d == FEND) d = TFEND;
				else d = TFESC;
			}
		Buff[j++] = d;
	}
	ftStatus = FT_Write(ftHandle, Buff, j, &r);
	if (!FT_SUCCESS(ftStatus)) return false;
	if (r != j) return false;
	return true;
}


