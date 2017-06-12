unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.AppEvnts,
  Wake, MyWake;

type
  TMainForm = class(TForm)
    ApplicationEvents: TApplicationEvents;
    OutputMemo: TMemo;
    CommandGroupBox: TGroupBox;
    InfoButton: TButton;
    EchoButton: TButton;
    TimeOutLabel: TLabel;
    TimeOutEdit: TEdit;
    AddressLabel: TLabel;
    AddressEdit: TEdit;
    GroupBox1: TGroupBox;
    NumberLabel: TLabel;
    BaudRateLabel: TLabel;
    OpenButton: TButton;
    NumberComboBox: TComboBox;
    BaudRateEdit: TEdit;
    CloseButton: TButton;
    DebugCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure OpenButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure EchoButtonClick(Sender: TObject);
  private
    procedure OnTx(const AAddress: TWakeAddress; const ATxCommand: TWakeCommand;
      const ATxCount: TWakeSize; const ATxData: TWakeData);
    procedure OnRx(const ATimeOut: Cardinal; const AAddress: TWakeAddress;
      const ARxCommand: TWakeCommand; const ARxCount: TWakeSize;
      const ARxData: TWakeData);

    procedure InitWakeDevice;
    procedure GetAllPorts;

    function GetIntFromEdit(AEdit: TCustomEdit): Integer;
  public

  end;

var
  MainForm: TMainForm;

implementation

uses
  Languages;

{$R *.dfm}
{ TMainForm }

procedure TMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  OpenButton.Enabled := (NumberComboBox.Items.Count > 0) and
    not TMyWakeDevice.Instance.Opened;

  NumberComboBox.Enabled := not TMyWakeDevice.Instance.Opened;
  BaudRateEdit.Enabled := not TMyWakeDevice.Instance.Opened;

  CloseButton.Enabled := TMyWakeDevice.Instance.Opened;
  InfoButton.Enabled := TMyWakeDevice.Instance.Opened;
  EchoButton.Enabled := TMyWakeDevice.Instance.Opened;
  TimeOutEdit.Enabled := TMyWakeDevice.Instance.Opened;
  OutputMemo.Enabled := TMyWakeDevice.Instance.Opened;
  AddressEdit.Enabled := TMyWakeDevice.Instance.Opened;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitWakeDevice;

  GetAllPorts;
end;

function TMainForm.GetIntFromEdit(AEdit: TCustomEdit): Integer;
var
  ParamName: string;
begin
  try
    Result := StrToInt(AEdit.Text)
  except
    on e: EConvertError do
    begin
      AEdit.SelectAll;
      AEdit.SetFocus;

      if Trim(AEdit.TextHint) <> '' then
      begin
        ParamName := AEdit.TextHint
      end
      else
      begin
        ParamName := AEdit.Name;
      end;
      raise Exception.CreateResFmt(TLanguages.SInvalidParameter, [ParamName]);
    end;
  end;
end;

procedure TMainForm.InitWakeDevice;
begin
  TMyWakeDevice.Instance.OnTx := OnTx;
  TMyWakeDevice.Instance.OnRx := OnRx;

  BaudRateEdit.Text := IntToStr(TMyWakeDevice.BAUD_RATE);
end;

procedure TMainForm.GetAllPorts;
var
  Ports: TStringList;
begin
  Ports := TMyWakeDevice.Instance.GetPorts;
  try
    NumberComboBox.Items.Assign(Ports);
    if NumberComboBox.Items.Count > 0 then
    begin
      NumberComboBox.ItemIndex := 0;
    end;
  finally
    Ports.Free;
  end;
end;

procedure TMainForm.InfoButtonClick(Sender: TObject);
var
  TimeOut: Cardinal;
  Address: TWakeAddress;
  DeviceInfo: string;
begin
  TimeOut := GetIntFromEdit(TimeOutEdit);
  Address := GetIntFromEdit(AddressEdit);

  DeviceInfo := TMyWakeDevice.Instance.GetInfo(TimeOut, Address);
  OutputMemo.Lines.Add(Format(LoadStr(TLanguages.SResult), [DeviceInfo]));
end;

procedure TMainForm.EchoButtonClick(Sender: TObject);
var
  i: Integer;
  TimeOut: Cardinal;
  Compare: Boolean;
  Count: TWakeSize;
  Address: TWakeAddress;
  TxData: TWakeData;
  RxData: TWakeData;
begin
  TimeOut := GetIntFromEdit(TimeOutEdit);
  Address := StrToInt(AddressEdit.Text);

  Count := Random(TMyWakeDevice.Instance.MaxSizeTx);

  SetLength(TxData, Count);
  SetLength(RxData, TMyWakeDevice.Instance.MaxSizeRx);

  for i := 0 to Count - 1 do
    TxData[i] := Random($FF);

  Compare := TMyWakeDevice.Instance.Echo(TimeOut, Address, Count,
    TxData, RxData);

  OutputMemo.Lines.Add(Format(LoadStr(TLanguages.SResult),
    [BoolToStr(Compare, True)]));
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
var
  DeviceID: Cardinal;
  BaudRate: Cardinal;
begin
  DeviceID := StrToInt(NumberComboBox.Items.Strings[NumberComboBox.ItemIndex]);
  BaudRate := GetIntFromEdit(BaudRateEdit);

  TMyWakeDevice.Instance.OpenPort(DeviceID, BaudRate);
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  TMyWakeDevice.Instance.ClosePort;
end;

procedure TMainForm.OnRx(const ATimeOut: Cardinal; const AAddress: TWakeAddress;
  const ARxCommand: TWakeCommand; const ARxCount: TWakeSize;
  const ARxData: TWakeData);
var
  i: Integer;
  StringBuilder: TStringBuilder;
begin
  if DebugCheckBox.Checked then
  begin
    StringBuilder := TStringBuilder.Create;
    try
      StringBuilder.AppendFormat
        ('RX: Time=%s, TimeOut=%d, Address=$%.2x, Command=$%.2x, Count=%d, Data=',
        [DateTimeToStr(Now), ATimeOut, AAddress, ARxCommand, ARxCount]);

      if ARxCount = 0 then
      begin
        StringBuilder.Append('<Empty>');
      end
      else
      begin
        for i := 0 to ARxCount - 1 do
          StringBuilder.Append('$' + IntToHex(ARxData[i], 2) + ' ');
      end;

      OutputMemo.Lines.Add(StringBuilder.ToString);
    finally
      StringBuilder.Free;
    end;
  end;
end;

procedure TMainForm.OnTx(const AAddress: TWakeAddress;
  const ATxCommand: TWakeCommand; const ATxCount: TWakeSize;
  const ATxData: TWakeData);
var
  i: Integer;
  StringBuilder: TStringBuilder;
begin
  if DebugCheckBox.Checked then
  begin
    StringBuilder := TStringBuilder.Create;
    try
      StringBuilder.AppendFormat
        ('TX: Time=%s, Address=$%.2x, Command=$%.2x, Count=%d, Data=',
        [DateTimeToStr(Now), AAddress, ATxCommand, ATxCount]);
      if ATxCount = 0 then
      begin
        StringBuilder.Append('<Empty>');
      end
      else
      begin
        for i := 0 to ATxCount - 1 do
          StringBuilder.Append('$' + IntToHex(ATxData[i], 2) + ' ');
      end;

      OutputMemo.Lines.Add(StringBuilder.ToString);
    finally
      StringBuilder.Free;
    end;
  end;
end;

end.
