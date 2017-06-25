#ifndef WUSB_H
#define WUSB_H

#ifdef WUSB_Exports
#define WUSB_API __declspec(dllexport)
#else
#define WUSB_API __declspec(dllimport)
#endif

extern "C"
 {
  WUSB_API bool WINAPI AccessUSB(int DevNum);
  WUSB_API bool WINAPI OpenUSB(int DevNum, DWORD baud);
  WUSB_API bool WINAPI CloseUSB(void);
  WUSB_API bool WINAPI PurgeUSB(void);
  WUSB_API bool WINAPI RxFrameUSB(DWORD To, unsigned char &ADD,
             unsigned char &CMD, unsigned char &N, unsigned char *Data);
  WUSB_API bool WINAPI TxFrameUSB(unsigned char ADDR, unsigned char CMD,
             unsigned char N, unsigned char *Data);
  WUSB_API bool WINAPI NumUSB(DWORD &numDevs);
 }

#endif