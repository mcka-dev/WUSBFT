package com.krasutski.service;

import com.krasutski.exception.WakePortException;
import com.krasutski.language.Messages;
import com.krasutski.jna.WUSB;
import com.krasutski.exception.WakeDeviceException;
import com.sun.jna.Memory;
import com.sun.jna.ptr.ByteByReference;
import com.sun.jna.ptr.IntByReference;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@SuppressWarnings("unused")
public class Wake {

    private boolean opened;

    private static byte MAX_SIZE_TX = (byte) 255;
    private static byte MAX_SIZE_RX = (byte) 255;

    private byte maxSizeRx;
    private byte maxSizeTx;

    private byte[] txData;
    private byte[] rxData;

    private List<WakeListener> listeners = new ArrayList<>();

    public Wake() {
        this(MAX_SIZE_TX, MAX_SIZE_RX);
    }

    public Wake(byte maxSizeTx, byte maxSizeRx) {
        this.maxSizeTx = maxSizeTx;
        this.maxSizeRx = maxSizeRx;

        txData = new byte[Byte.toUnsignedInt(maxSizeTx)];
        rxData = new byte[Byte.toUnsignedInt(maxSizeRx)];
    }

    public void addListener(WakeListener listener) {
        listeners.add(listener);
    }

    public void removeListener(WakeListener listener) {
        listeners.remove(listener);
    }

    public boolean isOpened() {
        return opened;
    }

    public byte getMaxSizeRx() {
        return maxSizeRx;
    }

    public void setMaxSizeRx(byte maxSizeRx) {
        this.maxSizeRx = maxSizeRx;
    }

    public byte getMaxSizeTx() {
        return maxSizeTx;
    }

    public void setMaxSizeTx(byte maxSizeTx) {
        this.maxSizeTx = maxSizeTx;
    }

    private byte executeCommand(int timeOut,
                                byte address, byte txCommand,
                                byte txCount, byte[] txData,
                                byte[] rxData) throws WakeDeviceException, WakePortException {

        purgePort();

        Memory memory = null;
        if (txCount > (byte) 0) {
            memory = new Memory(Byte.toUnsignedLong(txCount));
            memory.write(0L, txData, 0, Byte.toUnsignedInt(txCount));
        }

        for (WakeListener listener : listeners) {
            listener.doTX(address, txCommand, txCount, txData);
        }

        if (!WUSB.INSTANCE.TxFrameUSB(address, txCommand, txCount, memory)) {
            throw new WakePortException(Messages.WAKE_PORT_SEND_FRAME_ERROR);
        }

        ByteByReference rxAddress = new ByteByReference();
        ByteByReference rxCommand = new ByteByReference();
        ByteByReference rxCount = new ByteByReference();

        memory = new Memory(Byte.toUnsignedLong(maxSizeRx));
        if (!WUSB.INSTANCE.RxFrameUSB(timeOut, rxAddress, rxCommand, rxCount, memory)) {
            throw new WakePortException(Messages.WAKE_PORT_RECEIVE_FRAME_ERROR);
        }

        if (txCommand != rxCommand.getValue()) {
            throw new WakePortException(Messages.WAKE_PORT_COMMAND_NOT_MATCH);
        }

        if (rxCount.getValue() > (byte) 0) {
            memory.read(0L, rxData, 0, Byte.toUnsignedInt(rxCount.getValue()));
            checkErrorCode(rxCommand.getValue(), rxData[0]);
        }

        for (WakeListener listener : listeners) {
            listener.doRX(timeOut, rxAddress.getValue(), rxCommand.getValue(), rxCount.getValue(), rxData);
        }

        return rxCount.getValue();
    }

    private void checkErrorCode(byte command,
                                byte errorCode) throws WakeDeviceException {
        if (command != WUSB.ID_INFO && command != WUSB.ID_ECHO && errorCode != (byte) 0) {
            String errorMessage;
            switch (Byte.toUnsignedInt(errorCode)) {
                case 0x01:
                    errorMessage = Messages.WAKE_DEVICE_IO_ERROR;
                    break;
                case 0x02:
                    errorMessage = Messages.WAKE_DEVICE_DEVICE_BUSY_ERROR;
                    break;
                case 0x03:
                    errorMessage = Messages.WAKE_DEVICE_DEVICE_NOT_READY;
                    break;
                case 0x04:
                    errorMessage = Messages.WAKE_DEVICE_PARAMETERS_ERROR;
                    break;
                case 0x05:
                    errorMessage = Messages.WAKE_DEVICE_DEVICE_NOT_RESPONDING_ERROR;
                    break;
                case 0x06:
                    errorMessage = Messages.WAKE_DEVICE_NO_CARRIER;
                    break;
                default:
                    errorMessage = Messages.WAKE_DEVICE_UNKNOWN_DEVICE_ERROR;
                    break;
            }
            throw new WakeDeviceException(errorMessage);
        }
    }

    public void openPort(int deviceID, int baudRate) throws WakePortException {
        if (opened) {
            throw new WakePortException(Messages.WAKE_PORT_OPENED);
        }

        opened = WUSB.INSTANCE.OpenUSB(deviceID, baudRate);
        if (!opened) {
            throw new WakePortException(Messages.WAKE_PORT_CANT_OPEN_PORT);
        }
    }

    public List<Long> getPorts() {
        List<Long> list = new ArrayList<>();

        IntByReference count = new IntByReference();
        if (WUSB.INSTANCE.NumUSB(count)) {
            for (int i = 0; i < count.getValue(); i++) {
                list.add((long) i);
            }
        }

        return list;
    }

    public void closePort() throws WakePortException {

        if (!opened) {
            throw new WakePortException(Messages.WAKE_PORT_NOT_OPENED);
        }

        if (!WUSB.INSTANCE.CloseUSB()) {
            throw new WakePortException(Messages.WAKE_PORT_CLOSE_ERROR);
        }

        opened = false;
    }

    @SuppressWarnings("WeakerAccess")
    public void purgePort() throws WakePortException {
        if (!opened) {
            throw new WakePortException(Messages.WAKE_PORT_NOT_OPENED);
        }

        if (!WUSB.INSTANCE.PurgeUSB()) {
            throw new WakePortException(Messages.WAKE_PORT_PURGE_ERROR);
        }
    }

    @SuppressWarnings("WeakerAccess")
    public String getInfo(int timeOut, byte address) throws Exception {
        executeCommand(timeOut, address, WUSB.ID_INFO, (byte) 0, txData, rxData);
        return new String(rxData, StandardCharsets.UTF_8.name());
    }

    @SuppressWarnings("WeakerAccess")
    public boolean getEcho(int timeOut, byte address, byte count, byte[] txData, byte[] rxData) throws Exception {
        byte rxCount = executeCommand(timeOut, address, WUSB.ID_ECHO, count, txData, rxData);
        return count == rxCount && ByteBuffer.wrap(txData,0, count).equals(ByteBuffer.wrap(rxData,0,rxCount));
    }

    public interface WakeListener {
        void doRX(int timeOut, byte rxAddress, byte rxCommand, byte rxCount, byte[] rxData);

        void doTX(byte txAddress, byte txCommand, byte txCount, byte[] txData);
    }
}
