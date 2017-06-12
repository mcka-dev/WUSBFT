unit MyWake;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  Wake;

type
  TMyWakeDevice = class(TWakeDevice)
  private const
    // The maximum size package for My Device
    MAX_SIZE_TX = 15;
    MAX_SIZE_RX = 15;
  public const
    // Commands
    // ID_GETPWM: TWakeCommand = $0B;
    // ID_XXX: TWakeCommand = $0C;

    // BAUD_RATE for My Device
    BAUD_RATE: Cardinal = 38400;
  strict private
    // Singleton pattern
    class var FInstance: TMyWakeDevice;
    class function GetInstance: TMyWakeDevice; static;

    class destructor Destroy;

    constructor Create; reintroduce;
  public
    class property Instance: TMyWakeDevice read GetInstance;

    function OpenPort(ADeviceID: Cardinal): Boolean; overload;

    // procedure Cmd_GetPWM(out PWM1: Byte; out PWM2: Byte; out PWM3: Byte;
    // out PWM4: Byte; out PWM5: Byte; out PWM6: Byte);
    // procedure Cmd_SetXXX();
  end;

implementation

uses
  Languages;

{ TMyWakeDevice }

class destructor TMyWakeDevice.Destroy;
begin
  TMyWakeDevice.Instance.Free;
end;

constructor TMyWakeDevice.Create;
begin
  inherited Create(MAX_SIZE_TX, MAX_SIZE_RX);
end;

class function TMyWakeDevice.GetInstance: TMyWakeDevice;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TMyWakeDevice.Create;
  end;
  Result := FInstance;
end;

function TMyWakeDevice.OpenPort(ADeviceID: Cardinal): Boolean;
begin
  Result := inherited OpenPort(ADeviceID, BAUD_RATE);
end;

{
  procedure TMyWakeDevice.Cmd_GetPWM(out PWM1: Byte; out PWM2: Byte;
  out PWM3: Byte; out PWM4: Byte; out PWM5: Byte; out PWM6: Byte);
  var
  TxData: TWakeData;
  RxData: TWakeData;
  Count: TWakeSize;
  begin
  Count := ExecuteCommand(100, 0, ID_GETPWM, 0, TxData, RxData);
  if Count <> 6 then
  raise EWakeDeviceException.CreateRes(TLanguages.SIOError);

  PWM1 := RxData[1];
  PWM2 := RxData[2];
  PWM3 := RxData[3];
  PWM4 := RxData[4];
  PWM5 := RxData[5];
  PWM6 := RxData[6];
  end;

  procedure TMyWakeDevice.Cmd_SetXXX();
  begin
  ...
  end;
}

end.
