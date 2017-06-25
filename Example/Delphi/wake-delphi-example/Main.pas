unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.AppEvnts,
  Wake, MyWake, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    ApplicationEvents: TApplicationEvents;
    OutputMemo: TMemo;
    CommandGroupBox: TGroupBox;
    GroupBoxPort: TGroupBox;
    TopGridPanel: TGridPanel;
    NumberLabel: TLabel;
    NumberComboBox: TComboBox;
    BaudRateLabel: TLabel;
    BaudRateEdit: TEdit;
    OpenButton: TButton;
    CloseButton: TButton;
    BottomGridPanel: TGridPanel;
    AddressLabel: TLabel;
    AddressEdit: TEdit;
    TimeOutLabel: TLabel;
    TimeOutEdit: TEdit;
    InfoButton: TButton;
    EchoButton: TButton;
    DebugCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure OpenButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure EchoButtonClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private const
    RX_FORMAT = 'RX: Time=%s, TimeOut=%d, Address=$%.2x, Command=$%.2x, Count=%d, Data=';
    TX_FORMAT = 'TX: Time=%s, Address=$%.2x, Command=$%.2x, Count=%d, Data=';
    HEX_SEPARATOR = ' ';
  private
    procedure OnTx(const AAddress: TWakeAddress; const ATxCommand: TWakeCommand;
      const ATxCount: TWakeSize; const ATxData: TWakeData);
    procedure OnRx(const ATimeOut: Cardinal; const AAddress: TWakeAddress;
      const ARxCommand: TWakeCommand; const ARxCount: TWakeSize;
      const ARxData: TWakeData);

    procedure InitWakeDevice;
    procedure GetAllPorts;
    procedure Language;

    function GetIntFromEdit(AEdit: TCustomEdit): Integer;
  public

  end;

var
  MainForm: TMainForm;

implementation

uses
  Messages;

{$R *.dfm}
{ TMainForm }

procedure TMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  OpenButton.Enabled := (NumberComboBox.Items.Count > 0) and
    not TMyWakeDevice.Instance.Opened and (Trim(BaudRateEdit.Text) <> '');

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

  Language;

  GetAllPorts;
end;

procedure TMainForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('O'))  then
  begin
    if OpenButton.Enabled then
      OpenButton.Click;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('L'))  then
  begin
    if CloseButton.Enabled then
      CloseButton.Click;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('I'))  then
  begin
    if InfoButton.Enabled then
      InfoButton.Click;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('E'))  then
  begin
    if EchoButton.Enabled then
      EchoButton.Click;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('D'))  then
  begin
    if DebugCheckBox.Enabled then
      DebugCheckBox.Checked := not DebugCheckBox.Checked;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('N'))  then
  begin
    if NumberComboBox.Enabled then
    begin
      NumberComboBox.SetFocus;
      NumberComboBox.DroppedDown := true;
    end;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('T'))  then
  begin
    if TimeOutEdit.Enabled then
    begin
      TimeOutEdit.SetFocus;
    end;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('A'))  then
  begin
    if AddressEdit.Enabled then
    begin
      AddressEdit.SetFocus;
    end;
    Handled := True;
  end;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('B'))  then
  begin
    if BaudRateEdit.Enabled then
    begin
      BaudRateEdit.SetFocus;
    end;
    Handled := True;
  end;

end;

procedure TMainForm.Language;
begin
  Caption := LoadStr(TMessages.Title);

  NumberLabel.Caption := LoadStr(TMessages.NumberLabelText);
  BaudRateLabel.Caption := LoadStr(TMessages.BaudRateLabelText);
  AddressLabel.Caption := LoadStr(TMessages.AddressLabelText);
  TimeOutLabel.Caption := LoadStr(TMessages.TimeOutLabelText);

  OpenButton.Caption := LoadStr(TMessages.OpenButtonText);
  CloseButton.Caption := LoadStr(TMessages.CloseButtonText);

  GroupBoxPort.Caption := LoadStr(TMessages.PortLabelText);
  CommandGroupBox.Caption := LoadStr(TMessages.CommandsLabelText);
  InfoButton.Caption := LoadStr(TMessages.InfoButtonText);
  EchoButton.Caption := LoadStr(TMessages.EchoButtonText);

  AddressEdit.TextHint := LoadStr(TMessages.AddressPromptText);
  BaudRateEdit.TextHint := LoadStr(TMessages.BaudRatePromptText);
  TimeOutEdit.TextHint := LoadStr(TMessages.TimeOutPromptText);

  DebugCheckBox.Caption := LoadStr(TMessages.DebugComboBoxText);
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
      raise Exception.CreateResFmt(TMessages.InvalidParameter, [AEdit.Text, ParamName]);
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
  OutputMemo.Lines.Add(Format(LoadStr(TMessages.Result), [DeviceInfo]));
end;

procedure TMainForm.EchoButtonClick(Sender: TObject);
var
  i: Integer;
  s: string;
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

  if Compare then
    s := LoadStr(TMessages.Match)
  else
    s := LoadStr(TMessages.NotMatch);

  OutputMemo.Lines.Add(Format(LoadStr(TMessages.Result),
    [s]));
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
        (RX_FORMAT,
        [DateTimeToStr(Now), ATimeOut, AAddress, ARxCommand, ARxCount]);

      if ARxCount = 0 then
      begin
        StringBuilder.Append(LoadStr(TMessages.Empty));
      end
      else
      begin
        for i := 0 to ARxCount - 1 do
          StringBuilder.Append('$' + IntToHex(ARxData[i], 2) + HEX_SEPARATOR);
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
        (TX_FORMAT,
        [DateTimeToStr(Now), AAddress, ATxCommand, ATxCount]);
      if ATxCount = 0 then
      begin
        StringBuilder.Append(LoadStr(TMessages.Empty));
      end
      else
      begin
        for i := 0 to ATxCount - 1 do
          StringBuilder.Append('$' + IntToHex(ATxData[i], 2) + HEX_SEPARATOR);
      end;

      OutputMemo.Lines.Add(StringBuilder.ToString);
    finally
      StringBuilder.Free;
    end;
  end;
end;

end.
