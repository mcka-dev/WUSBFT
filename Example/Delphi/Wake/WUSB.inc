const
{$IFDEF MSWINDOWS}
{$IFDEF WIN32}
  wusb_dll = 'wusb32.dll';
{$ENDIF}
{$IFDEF WIN64}
  wusb_dll = 'wusb64.dll';
{$ENDIF}
{$ELSE}
{$ENDIF}
function AccessUSB(devID: Integer): BOOL; stdcall; external wusb_dll;
function OpenUSB(devID: Integer; Baud: DWORD): BOOL; stdcall; external wusb_dll;
function CloseUSB: BOOL; stdcall; external wusb_dll;
function PurgeUSB: BOOL; stdcall; external wusb_dll;
function RxFrameUSB(Timeout: DWORD; var Addr: UCHAR; var Cmd: UCHAR;
  var Count: UCHAR; Data: Pointer): BOOL; stdcall; external wusb_dll;
function TxFrameUSB(Addr: UCHAR; Cmd: UCHAR; Count: UCHAR; Data: Pointer): BOOL;
  stdcall; external wusb_dll;
function NumUSB(var numDevs: DWORD): BOOL; stdcall; external wusb_dll;
