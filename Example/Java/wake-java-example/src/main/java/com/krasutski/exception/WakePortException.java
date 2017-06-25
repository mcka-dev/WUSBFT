package com.krasutski.exception;

import java.io.IOException;

@SuppressWarnings("unused")
public class WakePortException extends IOException {
    public WakePortException() {
        super();
    }

    public WakePortException(Throwable cause) {
        super(cause);
    }

    public WakePortException(String message, Throwable cause) {
        super(message, cause);
    }

    public WakePortException(String message) {
        super(message);
    }
}
