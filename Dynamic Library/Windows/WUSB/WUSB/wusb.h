#ifndef WUSB_H
#define WUSB_H

#ifdef _WINDOWS
#define EXTERN_HEADER extern "C" __declspec(dllexport)
#define WINAPI __stdcall
#else
#define EXTERN_HEADER extern "C"
#endif

EXTERN_HEADER bool AccessUSB(int DevNum);
EXTERN_HEADER bool OpenUSB(int DevNum, unsigned int baud);
EXTERN_HEADER bool CloseUSB(void);
EXTERN_HEADER bool PurgeUSB(void);
EXTERN_HEADER bool RxFrameUSB(unsigned int To, unsigned char &ADD,
	unsigned char &CMD, unsigned char &N, unsigned char *Data);
EXTERN_HEADER bool TxFrameUSB(unsigned char ADDR, unsigned char CMD,
	unsigned char N, unsigned char *Data);
EXTERN_HEADER bool NumUSB(unsigned int &numDevs);

#endif
