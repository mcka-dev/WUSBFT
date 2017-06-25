unit Messages;

interface

type
  TMessages = class
  public const
    Title = 1000;

    IOError = 2001;
    DeviceBusyError = 2002;
    DeviceNotReady = 2003;
    ParametersError = 2004;
    DeviceNotRespondingError = 2005;
    NoCarrier = 2006;
    UnknownDeviceError = 2007;

    PortNotOpened = 3001;
    CantOpenPort = 3002;
    SendFrameError = 3003;
    ReceiveFrameError = 3004;
    PurgeError = 3005;

    InvalidParameter = 4000;

    Result = 4001;
    Empty = 4002;
    Match = 4003;
    NotMatch = 4004;

    DialogErrorHeader = 4005;

    NumberLabelText = 4006;
    AddressLabelText = 4007;
    TimeOutLabelText = 4008;
    BaudRateLabelText = 4009;

    AddressPromptText = 4010;
    TimeOutPromptText = 4011;
    BaudRatePromptText = 4012;

    OpenButtonText = 4013;
    CloseButtonText = 4014;
    InfoButtonText = 4015;
    EchoButtonText = 4016;

    DebugComboBoxText = 4017;

    CommandsLabelText = 4018;
    PortLabelText = 4019;
  end;

implementation

end.
