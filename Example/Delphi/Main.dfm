object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Wake Delphi example'
  ClientHeight = 412
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    527
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object OutputMemo: TMemo
    Left = 8
    Top = 64
    Width = 511
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object CommandGroupBox: TGroupBox
    Left = 8
    Top = 346
    Width = 511
    Height = 58
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Commands '
    TabOrder = 1
    object TimeOutLabel: TLabel
      Left = 110
      Top = 24
      Width = 64
      Height = 13
      Caption = 'TimeOut, ms:'
    end
    object AddressLabel: TLabel
      Left = 7
      Top = 24
      Width = 43
      Height = 13
      Caption = 'Address:'
    end
    object InfoButton: TButton
      Left = 231
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Info'
      TabOrder = 0
      OnClick = InfoButtonClick
    end
    object EchoButton: TButton
      Left = 312
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Echo'
      TabOrder = 1
      OnClick = EchoButtonClick
    end
    object TimeOutEdit: TEdit
      Left = 180
      Top = 21
      Width = 45
      Height = 21
      TabOrder = 2
      Text = '100'
      TextHint = 'TimeOut'
    end
    object AddressEdit: TEdit
      Left = 56
      Top = 21
      Width = 45
      Height = 21
      TabOrder = 3
      Text = '0'
      TextHint = 'Address'
    end
    object DebugCheckBox: TCheckBox
      Left = 393
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Debug Log'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 511
    Height = 58
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Port '
    TabOrder = 2
    object NumberLabel: TLabel
      Left = 9
      Top = 23
      Width = 41
      Height = 13
      Caption = 'Number:'
    end
    object BaudRateLabel: TLabel
      Left = 119
      Top = 23
      Width = 54
      Height = 13
      Caption = 'Baud Rate:'
    end
    object OpenButton: TButton
      Left = 230
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = OpenButtonClick
    end
    object NumberComboBox: TComboBox
      Left = 56
      Top = 20
      Width = 50
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object BaudRateEdit: TEdit
      Left = 179
      Top = 20
      Width = 45
      Height = 21
      TabOrder = 2
      TextHint = 'Baud Rate'
    end
    object CloseButton: TButton
      Left = 311
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 3
      OnClick = CloseButtonClick
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 48
    Top = 80
  end
end
