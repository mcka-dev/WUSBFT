unit Wake;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils;

type
  TWakeAddress = Byte;
  TWakeCommand = Byte;
  TWakeSize = Byte;
  TWakeData = array of Byte;

  EWakeDeviceException = class(Exception);

  TOnTx = procedure(const AAddress: TWakeAddress; const ACommand: TWakeCommand;
    const ACount: TWakeSize; const AData: TWakeData) of Object;
  TOnRx = procedure(const ATimeOut: Cardinal; const AAddress: TWakeAddress;
    const ACommand: TWakeCommand; const ACount: TWakeSize;
    const AData: TWakeData) of Object;

  TWakeDevice = class(TObject)
  private const
    MAX_SIZE_TX = 255;
    MAX_SIZE_RX = 255;
  public const
    ID_NOP: TWakeCommand = $00;
    ID_ERROR: TWakeCommand = $01;
    ID_ECHO: TWakeCommand = $02;
    ID_INFO: TWakeCommand = $03;
  private
    FCriticalSection: TRTLCriticalSection;

    FOpened: Boolean;

    FOnRx: TOnRx;
    FOnTX: TOnTx;

    FMaxSizeRx: TWakeSize;
    FMaxSizeTx: TWakeSize;
  protected
    FTxData: TWakeData;
    FRxData: TWakeData;

    procedure Lock;
    procedure UnLock;

    function ExecuteCommand(const ATimeOut: Cardinal;
      const AAddress: TWakeAddress; const ATxCommand: TWakeCommand;
      const ATxCount: TWakeSize; const ATxData: TWakeData;
      var ARxData: TWakeData): TWakeSize; virtual;

    procedure CheckErrorCode(const ACommand: TWakeCommand;
      const AErrorCode: Byte); virtual;

    procedure DoTxFrame(const AAddress: TWakeAddress;
      const AtxCmd: TWakeCommand; const ATxCount: TWakeSize;
      const ATxData: TWakeData); virtual;
    procedure DoRxFrame(const ATimeOut: Cardinal; const AAddress: TWakeAddress;
      const ARxCommand: TWakeCommand; const ARxCount: TWakeSize;
      const ARxData: TWakeData); virtual;
  public
    constructor Create(AMaxSizeTx: TWakeSize = MAX_SIZE_TX;
      AMaxSizeRx: TWakeSize = MAX_SIZE_RX); reintroduce; virtual;
    destructor Destroy; override;

    procedure OpenPort(ADeviceID: Cardinal; ABaudRate: Cardinal); overload;
    function AccessPort(ADeviceID: Cardinal): Boolean;
    function ClosePort: Boolean;
    procedure PurgePort;

    function GetPorts: TStringList;

    function GetInfo(ATimeOut: Cardinal; AAddress: TWakeAddress): string;
    function Echo(ATimeOut: Cardinal; AAddress: TWakeAddress; ACount: TWakeSize;
      const ATxData: TWakeData; var ARxData: TWakeData): Boolean;

    property Opened: Boolean read FOpened;

    property OnTx: TOnTx read FOnTX write FOnTX;
    property OnRx: TOnRx read FOnRx write FOnRx;

    property MaxSizeTx: TWakeSize read FMaxSizeTx;
    property MaxSizeRx: TWakeSize read FMaxSizeRx;
  end;

implementation

uses
  Messages;

{$I Wake\WUSB.inc}

function TWakeDevice.GetPorts: TStringList;
var
  i: Integer;
  USBCount: Cardinal;
begin
  Lock;
  try
    Result := TStringList.Create;
    if NumUSB(USBCount) then
    begin
      for i := 0 to USBCount - 1 do
        Result.Add(IntToStr(i));
    end;
  finally
    UnLock;
  end;
end;

function TWakeDevice.ClosePort: Boolean;
begin
  Lock;
  try
    FOpened := False;
    Result := CloseUSB;
  finally
    UnLock;
  end;
end;

constructor TWakeDevice.Create(AMaxSizeTx: TWakeSize = MAX_SIZE_TX;
  AMaxSizeRx: TWakeSize = MAX_SIZE_RX);
begin
  FMaxSizeTx := AMaxSizeTx;
  FMaxSizeRx := AMaxSizeRx;

  SetLength(FTxData, AMaxSizeTx);
  SetLength(FRxData, AMaxSizeRx);

  InitializeCriticalSection(FCriticalSection);
end;

destructor TWakeDevice.Destroy;
begin
  if FOpened then
  begin
    ClosePort;
  end;

  DeleteCriticalSection(FCriticalSection);

  inherited;
end;

procedure TWakeDevice.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TWakeDevice.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

procedure TWakeDevice.DoTxFrame;
begin
  if Assigned(FOnTX) then
  begin
    FOnTX(AAddress, AtxCmd, ATxCount, ATxData)
  end;
end;

procedure TWakeDevice.DoRxFrame;
begin
  if Assigned(FOnRx) then
  begin
    FOnRx(ATimeOut, AAddress, ARxCommand, ARxCount, ARxData);
  end;
end;

procedure TWakeDevice.OpenPort(ADeviceID: Cardinal; ABaudRate: Cardinal);
begin
  Lock;
  try
    FOpened := OpenUSB(ADeviceID, ABaudRate);
    if not FOpened then
    begin
      raise EWakeDeviceException.CreateRes(TMessages.CantOpenPort);
    end;

  finally
    UnLock;
  end;
end;

procedure TWakeDevice.PurgePort;
begin
  Lock;
  try
    if not FOpened then
    begin
      raise EWakeDeviceException.CreateRes(TMessages.PortNotOpened);
    end;

    if not PurgeUSB then
    begin
      raise EWakeDeviceException.CreateRes(TMessages.PurgeError);
    end;
  finally
    UnLock;
  end;
end;

function TWakeDevice.ExecuteCommand(const ATimeOut: Cardinal;
  const AAddress: TWakeAddress; const ATxCommand: TWakeCommand;
  const ATxCount: TWakeSize; const ATxData: TWakeData; var ARxData: TWakeData)
  : TWakeSize;
var
  RxAddress: TWakeAddress;
  RxCommand: TWakeCommand;
  RxCount: TWakeSize;
begin
  Lock;
  try
    PurgePort;

    DoTxFrame(AAddress, ATxCommand, ATxCount, ATxData);

    if not TxFrameUSB(AAddress, ATxCommand, ATxCount, ATxData) then
      raise EWakeDeviceException.CreateRes(TMessages.SendFrameError);

    ZeroMemory(ARxData, Length(ARxData));

    if not RxFrameUSB(ATimeOut, RxAddress, RxCommand, RxCount, ARxData) then
      raise EWakeDeviceException.CreateRes(TMessages.ReceiveFrameError);

    DoRxFrame(ATimeOut, RxAddress, RxCommand, RxCount, ARxData);

    if ATxCommand <> RxCommand then
      raise EWakeDeviceException.CreateRes(TMessages.IOError);

    if RxCount > 0 then
    begin
      CheckErrorCode(RxCommand, ARxData[0]);
    end;

    Result := RxCount;
  finally
    UnLock;
  end;
end;

function TWakeDevice.AccessPort(ADeviceID: Cardinal): Boolean;
begin
  Lock;
  try
    Result := AccessUSB(ADeviceID);
  finally
    UnLock;
  end;
end;

procedure TWakeDevice.CheckErrorCode(const ACommand: TWakeCommand;
  const AErrorCode: Byte);
var
  ErrorRes: NativeUInt;
begin
  if (not(ACommand in [ID_INFO, ID_ECHO])) and (AErrorCode <> 0) then
  begin
    case AErrorCode of
      $01:
        ErrorRes := TMessages.IOError;
      $02:
        ErrorRes := TMessages.DeviceBusyError;
      $03:
        ErrorRes := TMessages.DeviceNotReady;
      $04:
        ErrorRes := TMessages.ParametersError;
      $05:
        ErrorRes := TMessages.DeviceNotRespondingError;
      $06:
        ErrorRes := TMessages.NoCarrier;
    else
      ErrorRes := TMessages.UnknownDeviceError;
    end;

    raise EWakeDeviceException.CreateRes(ErrorRes);
  end;
end;

function TWakeDevice.GetInfo(ATimeOut: Cardinal;
  AAddress: TWakeAddress): string;
begin
  ExecuteCommand(ATimeOut, AAddress, TWakeDevice.ID_INFO, 0, FTxData, FRxData);
  Result := TEncoding.UTF8.GetString(FRxData);
end;

function TWakeDevice.Echo(ATimeOut: Cardinal; AAddress: TWakeAddress;
  ACount: TWakeSize; const ATxData: TWakeData; var ARxData: TWakeData): Boolean;
begin
  ExecuteCommand(ATimeOut, AAddress, TWakeDevice.ID_ECHO, ACount,
    ATxData, ARxData);
  Result := CompareMem(ATxData, ARxData, ACount);
end;

end.
