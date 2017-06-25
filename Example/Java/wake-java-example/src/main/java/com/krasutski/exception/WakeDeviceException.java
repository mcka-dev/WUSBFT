package com.krasutski.exception;

import java.io.IOException;

@SuppressWarnings("unused")
public class WakeDeviceException extends IOException {
    public WakeDeviceException() {
        super();
    }

    public WakeDeviceException(Throwable cause) {
        super(cause);
    }

    public WakeDeviceException(String message, Throwable cause) {
        super(message, cause);
    }

    public WakeDeviceException(String message) {
        super(message);
    }
}
