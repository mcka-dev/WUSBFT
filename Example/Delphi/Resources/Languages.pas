unit Languages;

interface

type
  TLanguages = class
  public const
    SIOError = 1001;
    SDeviceBusyError = 1002;
    SDeviceNotReady = 1003;
    SParametersError = 1004;
    SDeviceNotRespondingError = 1005;
    SNoCarrier = 1006;
    SUnknownDeviceError = 1007;
    SSendFrameError = 1008;
    SReceiveFrameError = 1009;
    SPurgeError = 1010;

    SInvalidParameter = 2000;
    SResult = 2001;
  end;

implementation

end.
