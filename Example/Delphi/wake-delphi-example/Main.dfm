object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Wake Delphi example'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShortCut = FormShortCut
  DesignSize = (
    640
    480)
  PixelsPerInch = 96
  TextHeight = 13
  object OutputMemo: TMemo
    Left = 8
    Top = 64
    Width = 624
    Height = 349
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
    ExplicitWidth = 608
    ExplicitHeight = 310
  end
  object CommandGroupBox: TGroupBox
    Left = 8
    Top = 414
    Width = 624
    Height = 58
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Commands '
    TabOrder = 1
    ExplicitTop = 375
    ExplicitWidth = 608
    object BottomGridPanel: TGridPanel
      Left = 2
      Top = 15
      Width = 620
      Height = 41
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAuto
          Value = 12.500000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 56.000000000000000000
        end
        item
          SizeStyle = ssAuto
          Value = 14.285714285714280000
        end
        item
          SizeStyle = ssAbsolute
          Value = 66.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 91.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 91.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = AddressLabel
          Row = 0
        end
        item
          Column = 1
          Control = AddressEdit
          Row = 0
        end
        item
          Column = 2
          Control = TimeOutLabel
          Row = 0
        end
        item
          Column = 3
          Control = TimeOutEdit
          Row = 0
        end
        item
          Column = 4
          Control = InfoButton
          Row = 0
        end
        item
          Column = 5
          Control = EchoButton
          Row = 0
        end
        item
          Column = 6
          Control = DebugCheckBox
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      ExplicitWidth = 604
      DesignSize = (
        620
        41)
      object AddressLabel: TLabel
        Left = 0
        Top = 11
        Width = 49
        Height = 19
        Alignment = taRightJustify
        Anchors = []
        Caption = 'Address:'
        FocusControl = AddressEdit
        GlowSize = 3
        Layout = tlCenter
        ExplicitLeft = -6
        ExplicitTop = 10
      end
      object AddressEdit: TEdit
        Left = 52
        Top = 10
        Width = 50
        Height = 21
        Anchors = []
        TabOrder = 0
        Text = '0'
        TextHint = 'Address'
      end
      object TimeOutLabel: TLabel
        Left = 105
        Top = 11
        Width = 70
        Height = 19
        Alignment = taRightJustify
        Anchors = []
        Caption = 'TimeOut, ms:'
        FocusControl = TimeOutEdit
        GlowSize = 3
        Layout = tlCenter
        ExplicitLeft = 103
        ExplicitTop = 10
      end
      object TimeOutEdit: TEdit
        Left = 178
        Top = 10
        Width = 60
        Height = 21
        Anchors = []
        TabOrder = 1
        Text = '100'
        TextHint = 'TimeOut'
        ExplicitLeft = 188
      end
      object InfoButton: TButton
        Left = 244
        Top = 8
        Width = 85
        Height = 25
        Anchors = []
        Caption = 'Info'
        TabOrder = 2
        OnClick = InfoButtonClick
        ExplicitLeft = 254
      end
      object EchoButton: TButton
        Left = 335
        Top = 8
        Width = 85
        Height = 25
        Anchors = []
        Caption = 'Echo'
        TabOrder = 3
        OnClick = EchoButtonClick
        ExplicitLeft = 345
      end
      object DebugCheckBox: TCheckBox
        Left = 423
        Top = 12
        Width = 160
        Height = 17
        Anchors = [akLeft]
        Caption = 'Debug Log'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
  end
  object GroupBoxPort: TGroupBox
    Left = 8
    Top = 0
    Width = 624
    Height = 58
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Port '
    TabOrder = 2
    ExplicitWidth = 608
    object TopGridPanel: TGridPanel
      Left = 2
      Top = 15
      Width = 620
      Height = 41
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAuto
          Value = 16.666666666666650000
        end
        item
          SizeStyle = ssAbsolute
          Value = 66.000000000000000000
        end
        item
          SizeStyle = ssAuto
          Value = 19.999999999999990000
        end
        item
          SizeStyle = ssAbsolute
          Value = 66.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 91.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 91.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = NumberLabel
          Row = 0
        end
        item
          Column = 1
          Control = NumberComboBox
          Row = 0
        end
        item
          Column = 2
          Control = BaudRateLabel
          Row = 0
        end
        item
          Column = 3
          Control = BaudRateEdit
          Row = 0
        end
        item
          Column = 4
          Control = OpenButton
          Row = 0
        end
        item
          Column = 5
          Control = CloseButton
          Row = 0
        end>
      DoubleBuffered = False
      ParentColor = True
      ParentDoubleBuffered = False
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      ExplicitWidth = 604
      DesignSize = (
        620
        41)
      object NumberLabel: TLabel
        Left = 0
        Top = 11
        Width = 47
        Height = 19
        Alignment = taRightJustify
        Anchors = []
        Caption = 'Number:'
        FocusControl = NumberComboBox
        GlowSize = 3
        Transparent = True
        Layout = tlCenter
        ExplicitLeft = -6
        ExplicitTop = 9
      end
      object NumberComboBox: TComboBox
        Left = 50
        Top = 10
        Width = 60
        Height = 21
        Style = csDropDownList
        Anchors = []
        TabOrder = 0
      end
      object BaudRateLabel: TLabel
        Left = 113
        Top = 11
        Width = 60
        Height = 19
        Alignment = taRightJustify
        Anchors = []
        Caption = 'Baud Rate:'
        FocusControl = BaudRateEdit
        GlowSize = 3
        Layout = tlCenter
        ExplicitLeft = 101
        ExplicitTop = 9
      end
      object BaudRateEdit: TEdit
        Left = 176
        Top = 10
        Width = 60
        Height = 21
        Anchors = []
        TabOrder = 1
        TextHint = 'Baud Rate'
      end
      object OpenButton: TButton
        Left = 242
        Top = 8
        Width = 85
        Height = 25
        Anchors = []
        Caption = 'Open'
        TabOrder = 2
        OnClick = OpenButtonClick
      end
      object CloseButton: TButton
        Left = 333
        Top = 8
        Width = 85
        Height = 25
        Anchors = []
        Caption = 'Close'
        TabOrder = 3
        OnClick = CloseButtonClick
      end
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 48
    Top = 80
  end
end
