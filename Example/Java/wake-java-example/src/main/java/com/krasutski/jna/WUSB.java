package com.krasutski.jna;

import com.krasutski.language.Messages;

import com.sun.jna.*;
import com.sun.jna.ptr.ByteByReference;
import com.sun.jna.ptr.IntByReference;

@SuppressWarnings("unused")
public final class WUSB {
    public static byte ID_NOP = (byte) 0x00;
    public static byte ID_ERROR = (byte) 0x01;
    public static byte ID_ECHO = (byte) 0x02;
    public static byte ID_INFO = (byte) 0x03;

    public static IWUSB INSTANCE;

    static {
        try {
            String libraryName;

            if (Platform.isLinux() || Platform.isWindows()) {
                if (Platform.is64Bit()) {
                    libraryName = "WUSB64";
                } else {
                    libraryName = "WUSB32";
                }
            } else {
                throw new UnsupportedOperationException(Messages.STRING_FORMAT_NOT_SUPPORTED);
            }

            Native.DEBUG_JNA_LOAD = true;
            Native.DEBUG_LOAD = true;

            NativeLibrary.addSearchPath(libraryName, "Native");
            INSTANCE = Native.loadLibrary(libraryName, IWUSB.class);

        } catch (UnsatisfiedLinkError | UnsupportedOperationException e) {
            System.out.println(e.getMessage());
            System.exit(-1);
        }
    }

    public interface IWUSB extends Library {
        boolean AccessUSB(int DevNum);

        boolean OpenUSB(int DevNum, int baud);

        boolean CloseUSB();

        boolean PurgeUSB();

        boolean RxFrameUSB(int To, ByteByReference ADDR, ByteByReference CMD, ByteByReference N, Pointer Data);

        boolean TxFrameUSB(byte ADDR, byte CMD, int N, Pointer Data);

        boolean NumUSB(IntByReference numDevs);
    }
}