package com.krasutski.language;

import static java.util.ResourceBundle.getBundle;
import static com.krasutski.util.ReflectionUtils.getUnsafeFieldValue;

import com.sun.javafx.scene.control.skin.resources.ControlResources;
import com.krasutski.util.PropertyLoader;

import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * The class with all messages of this application.
 */
public abstract class Messages {

    private static ResourceBundle BUNDLE;

    private static final String FIELD_NAME = "lookup";
    private static final String BUNDLE_NAME = "messages/messages";
    private static final String CONTROLS_BUNDLE_NAME = "com/sun/javafx/scene/control/skin/resources/controls";

    public static final String MAIN_APP_TITLE;

    public static final String WAKE_DEVICE_IO_ERROR;
    public static final String WAKE_DEVICE_DEVICE_BUSY_ERROR;
    public static final String WAKE_DEVICE_DEVICE_NOT_READY;
    public static final String WAKE_DEVICE_PARAMETERS_ERROR;
    public static final String WAKE_DEVICE_DEVICE_NOT_RESPONDING_ERROR;
    public static final String WAKE_DEVICE_NO_CARRIER;
    public static final String WAKE_DEVICE_UNKNOWN_DEVICE_ERROR;

    public static final String WAKE_PORT_SEND_FRAME_ERROR;
    public static final String WAKE_PORT_RECEIVE_FRAME_ERROR;
    public static final String WAKE_PORT_PURGE_ERROR;
    public static final String WAKE_PORT_NOT_OPENED;
    public static final String WAKE_PORT_CANT_OPEN_PORT;
    public static final String WAKE_PORT_OPENED;
    public static final String WAKE_PORT_CLOSE_ERROR;
    public static final String WAKE_PORT_COMMAND_NOT_MATCH;

    public static final String STRING_FORMAT_NOT_SUPPORTED;
    public static final String STRING_FORMAT_INVALID_PARAMETER;
    public static final String STRING_FORMAT_RESULT;

    public static final String STRING_EMPTY;
    public static final String STRING_MATCH;
    public static final String STRING_NOT_MATCH;

    public static final String DIALOG_ERROR_HEADER;

    static {
        final Locale locale = Locale.getDefault();
        final ClassLoader classLoader = ControlResources.class.getClassLoader();

        final ResourceBundle controlBundle = getBundle(CONTROLS_BUNDLE_NAME,
                locale, classLoader, PropertyLoader.getInstance());

        final ResourceBundle overrideBundle = getBundle(CONTROLS_BUNDLE_NAME,
                PropertyLoader.getInstance());

        final Map override = getUnsafeFieldValue(overrideBundle, FIELD_NAME);
        final Map original = getUnsafeFieldValue(controlBundle, FIELD_NAME);

        //noinspection ConstantConditions,ConstantConditions,unchecked
        original.putAll(override);

        BUNDLE = getBundle(BUNDLE_NAME, PropertyLoader.getInstance());

        MAIN_APP_TITLE = BUNDLE.getString("MainApp.title");

        WAKE_DEVICE_IO_ERROR = BUNDLE.getString("WakeDevice.IOError");
        WAKE_DEVICE_DEVICE_BUSY_ERROR = BUNDLE.getString("WakeDevice.DeviceBusyError");
        WAKE_DEVICE_DEVICE_NOT_READY = BUNDLE.getString("WakeDevice.DeviceNotReady");
        WAKE_DEVICE_PARAMETERS_ERROR = BUNDLE.getString("WakeDevice.ParametersError");
        WAKE_DEVICE_DEVICE_NOT_RESPONDING_ERROR = BUNDLE.getString("WakeDevice.DeviceNotRespondingError");
        WAKE_DEVICE_NO_CARRIER = BUNDLE.getString("WakeDevice.NoCarrier");
        WAKE_DEVICE_UNKNOWN_DEVICE_ERROR = BUNDLE.getString("WakeDevice.UnknownDeviceError");

        WAKE_PORT_SEND_FRAME_ERROR = BUNDLE.getString("WakePort.SendFrameError");
        WAKE_PORT_RECEIVE_FRAME_ERROR = BUNDLE.getString("WakePort.ReceiveFrameError");
        WAKE_PORT_PURGE_ERROR = BUNDLE.getString("WakePort.PurgeError");
        WAKE_PORT_NOT_OPENED = BUNDLE.getString("WakePort.PortNotOpened");
        WAKE_PORT_CANT_OPEN_PORT = BUNDLE.getString("WakePort.CantOpenPort");
        WAKE_PORT_CLOSE_ERROR = BUNDLE.getString("WakePort.CloseError");
        WAKE_PORT_OPENED = BUNDLE.getString("WakePort.PortOpened");
        WAKE_PORT_COMMAND_NOT_MATCH = BUNDLE.getString("WakePort.CommandNotMatch");

        STRING_FORMAT_INVALID_PARAMETER = BUNDLE.getString("String.format.InvalidParameter");
        STRING_FORMAT_RESULT = BUNDLE.getString("String.format.Result");
        STRING_FORMAT_NOT_SUPPORTED = BUNDLE.getString("String.format.NotSupported");

        STRING_EMPTY = BUNDLE.getString("String.empty");
        STRING_MATCH = BUNDLE.getString("String.match");
        STRING_NOT_MATCH = BUNDLE.getString("String.notMatch");

        DIALOG_ERROR_HEADER = BUNDLE.getString("Dialog.error.header");
    }

    public static ResourceBundle GetBundle() {
        return BUNDLE;
    }
}