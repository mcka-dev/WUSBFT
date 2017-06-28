package com.krasutski.jni;

import com.krasutski.language.Messages;

import java.io.File;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;

@SuppressWarnings("unused")
public final class WUSB {
    public static byte ID_NOP = (byte) 0x00;
    public static byte ID_ERROR = (byte) 0x01;
    public static byte ID_ECHO = (byte) 0x02;
    public static byte ID_INFO = (byte) 0x03;

    public static WUSB INSTANCE;

    public native boolean AccessUSB(int DevNum);

    public native boolean OpenUSB(int DevNum, int baud);

    public native boolean CloseUSB();

    public native boolean PurgeUSB();

    public native boolean RxFrameUSB(int To, Byte ADDR, Byte CMD, Byte N, ByteBuffer data);

    public native boolean TxFrameUSB(byte ADDR, byte CMD, byte N, ByteBuffer data);

    public native boolean NumUSB(Integer numDevs);

    private WUSB() {
        super();
    }

    static {
        try {
            final String OS = System.getProperty("os.name").toLowerCase();
            final String arch = System.getProperty("sun.arch.data.model");
            String libraryName = "";

            if (OS.contains("win") || OS.contains("nux")) {
                if (arch.contains("64")) {
                    libraryName = "WUSB64";
                } else {
                    libraryName = "WUSB32";
                }
            } else {
                System.out.println(OS);
                throw new UnsupportedOperationException(Messages.STRING_FORMAT_NOT_SUPPORTED);
            }

            try {
                System.setProperty("java.library.path",
                        System.getProperty("java.library.path") + File.pathSeparator + "." + File.pathSeparator +"./Native/" );
                Field fieldSysPath = ClassLoader.class.getDeclaredField( "sys_paths" );
                fieldSysPath.setAccessible( true );
                fieldSysPath.set( null, null );

                System.loadLibrary(libraryName);

                INSTANCE = new WUSB();

            }
            catch (UnsatisfiedLinkError | UnsupportedOperationException e) {
                System.out.println("Properties");
                System.out.println("----------");
                System.out.println("user.home=" + System.getProperty("user.home"));
                System.out.println("user.dir=" + System.getProperty("user.dir"));
                System.out.println("java.library.path=" + System.getProperty("java.library.path"));
                System.out.println("");
                System.out.println("Environments");
                System.out.println("------------");
                System.out.println("PATH=" + System.getenv("PATH"));
                System.out.println("LD_LIBRARY_PATH=" + System.getenv("LD_LIBRARY_PATH"));
                System.out.println("");
                throw e;
            }

        } catch (Throwable t) {
            System.out.println(t.getMessage());
            System.exit(-1);
        }
    }
}