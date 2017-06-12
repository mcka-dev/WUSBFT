unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.AppEvnts,
  MyWake;

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
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure OpenButtonClick(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure EchoButtonClick(Sender: TObject);
  public
  end;

var
  MainForm: TMainForm;

implementation

uses
  Wake, ru_RU;

{$R *.dfm}

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
  NumberComboBox.Items.Assign(TMyWakeDevice.Instance.GetPorts);
  if NumberComboBox.Items.Count > 0 then
  begin
    NumberComboBox.ItemIndex := 0;
  end;
end;

procedure TMainForm.InfoButtonClick(Sender: TObject);
var
  TimeOut: Integer;
  Address: Integer;
  DeviceInfo: string;
begin
  try
    TimeOut := StrToInt(TimeOutEdit.Text)
  except
    on e: EConvertError do
      raise Exception.CreateFmt(SInvalidParameter, ['TimeOut']);
  end;

  try
    Address := StrToInt(AddressEdit.Text)
  except
    on e: EConvertError do
      raise Exception.CreateFmt(SInvalidParameter, ['Address']);
  end;

  DeviceInfo := TMyWakeDevice.Instance.GetInfo(TimeOut, Address);
  OutputMemo.Lines.Add('Result: ' + DeviceInfo);
end;

procedure TMainForm.EchoButtonClick(Sender: TObject);
var
  Count: Integer;
  TimeOut: Integer;
  Address: Integer;
  TxData: TWakeData;
  RxData: TWakeData;
  Compare: Boolean;
begin
  try
    TimeOut := StrToInt(TimeOutEdit.Text)
  except
    on e: EConvertError do
      raise Exception.CreateFmt(SInvalidParameter, ['TimeOut']);
  end;

  try
    Address := StrToInt(AddressEdit.Text)
  except
    on e: EConvertError do
      raise Exception.CreateFmt(SInvalidParameter, ['Address']);
  end;

  Count := Random(MAX_DATA_SIZE - 1);

  Compare := TMyWakeDevice.Instance.Echo(TimeOut, Address, Count,
    TxData, RxData);

  OutputMemo.Lines.Add('Result: ' + BoolToStr(Compare, True));
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
var
  BaudRate: Integer;
begin
  try
    BaudRate := StrToInt(BaudRateEdit.Text);
  except
    on e: EConvertError do
      raise Exception.CreateFmt(SInvalidParameter, ['BaudRate']);
  end;
  TMyWakeDevice.Instance.OpenPort
    (StrToInt(NumberComboBox.Items.Strings[NumberComboBox.ItemIndex]),
    BaudRate);
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  TMyWakeDevice.Instance.ClosePort;
end;

end.
