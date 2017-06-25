package com.krasutski.view;

import com.krasutski.language.Messages;
import com.krasutski.service.Wake;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyCodeCombination;
import javafx.scene.input.KeyCombination;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

import java.net.URL;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.*;

public class MainController implements Initializable {
    // Update period in milliseconds
    private final static long portRefreshPeriod = 5000;

    private static final String TX_FORMAT = "TX: Time=%s, Address=0x%02X, Command=0x%02X, Count=%d, Data=";
    private static final String RX_FORMAT = "RX: Time=%s, TimeOut=%d, Address=0x%02X, Command=0x%02X, Count=%d, Data=";
    private static final String HEX_FORMAT = "0x%02X";
    private static final char HEX_SEPARATOR = ' ';

    private Timer timer = new java.util.Timer();

    private Wake wake;

    private BooleanProperty isOpened = new SimpleBooleanProperty();

    @FXML
    private Button infoButton;
    @FXML
    private Button echoButton;
    @FXML
    private Label numberLabel;
    @FXML
    private Label baudRateLabel;
    @FXML
    private CheckBox debugCheckBox;
    @FXML
    private Button openButton;
    @FXML
    private Button closeButton;
    @FXML
    private TextField addressTextField;
    @FXML
    private TextField timeOutTextField;
    @FXML
    private TextField baudRateTextField;
    @FXML
    private ComboBox<Long> numberComboBox;
    @FXML
    private TextArea outputTextArea;

    @FXML
    @SuppressWarnings("unused")
    private Pane topPane;
    @FXML
    @SuppressWarnings("unused")
    private Pane bottomPane;
    @FXML
    @SuppressWarnings("unused")
    private Label portLabel;
    @FXML
    @SuppressWarnings("unused")
    private Label commandsLabel;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        wake = new Wake((byte) 15, (byte) 15);
        wake.addListener(new Wake.WakeListener() {
            @Override
            public void doTX(byte txAddress, byte txCommand, byte txCount, byte[] txData) {
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.append(
                        String.format(TX_FORMAT,
                                ZonedDateTime.now().format(DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL)),
                                Byte.toUnsignedInt(txAddress),
                                Byte.toUnsignedInt(txCommand),
                                Byte.toUnsignedInt(txCount))
                );

                if (txCount == (byte) 0) {
                    stringBuilder.append(Messages.STRING_EMPTY);
                } else {
                    for (int i = 0; i < Byte.toUnsignedInt(txCount); i++) {
                        stringBuilder.append(String.format(HEX_FORMAT, txData[i])).append(HEX_SEPARATOR);
                    }
                }
                if (debugCheckBox.isSelected()) {
                    outputTextArea.appendText(stringBuilder.toString() + System.lineSeparator());
                }
                System.out.println(stringBuilder.toString());
            }

            @Override
            public void doRX(int timeOut, byte rxAddress, byte rxCommand, byte rxCount, byte[] rxData) {
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.append(
                        String.format(RX_FORMAT,
                                ZonedDateTime.now().format(DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL)),
                                timeOut,
                                Byte.toUnsignedInt(rxAddress),
                                Byte.toUnsignedInt(rxCommand),
                                Byte.toUnsignedInt(rxCount))
                );

                if (rxCount == (byte) 0) {
                    stringBuilder.append(Messages.STRING_EMPTY);
                } else {
                    for (int i = 0; i < Byte.toUnsignedInt(rxCount); i++) {
                        stringBuilder.append(String.format(HEX_FORMAT, rxData[i])).append(HEX_SEPARATOR);
                    }
                }
                if (debugCheckBox.isSelected()) {
                    outputTextArea.appendText(stringBuilder.toString() + System.lineSeparator());
                }
                System.out.println(stringBuilder.toString());
            }
        });

        updateControls();

        portRefreshTimer();
    }

    private void portRefreshTimer() {
        timer.schedule(new TimerTask() {
            private List<Long> oldList;

            public void run() {
                if (!isOpened.get()) {

                    List<Long> newList = wake.getPorts();

                    if (!newList.equals(oldList)) {
                        Platform.runLater(() -> {
                            System.out.println("List of ports: full update " + Arrays.toString(newList.toArray()));

                            numberComboBox.setItems(FXCollections.observableArrayList(newList));
                            if (numberComboBox.getSelectionModel().isEmpty() && numberComboBox.getItems().size() > 0) {
                                numberComboBox.getSelectionModel().selectFirst();
                            }
                            oldList = numberComboBox.getItems();
                        });
                    } else {
                        System.out.println("List of ports: no updates");
                    }
                }
            }
        }, 0, portRefreshPeriod);
    }

    public void setStage(Stage stage) {
        // Hot keys
        stage.addEventFilter(KeyEvent.KEY_PRESSED, (event -> {
            if (new KeyCodeCombination(KeyCode.O, KeyCombination.CONTROL_ANY).match(event)) {
                openButton.fire();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.L, KeyCombination.CONTROL_ANY).match(event)) {
                closeButton.fire();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.I, KeyCombination.CONTROL_ANY).match(event)) {
                infoButton.fire();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.E, KeyCombination.CONTROL_ANY).match(event)) {
                echoButton.fire();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.T, KeyCombination.CONTROL_ANY).match(event)) {
                timeOutTextField.requestFocus();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.N, KeyCombination.CONTROL_ANY).match(event)) {
                numberComboBox.requestFocus();
                numberComboBox.show();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.A, KeyCombination.CONTROL_ANY).match(event)) {
                addressTextField.requestFocus();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.B, KeyCombination.CONTROL_ANY).match(event)) {
                baudRateTextField.requestFocus();
                event.consume();
            }

            if (new KeyCodeCombination(KeyCode.D, KeyCombination.CONTROL_ANY).match(event)) {
                debugCheckBox.setSelected(!debugCheckBox.isSelected());
                event.consume();
            }
        }));

        // Stage is closing
        stage.setOnCloseRequest(e -> {
            try {
                timer.cancel();

                if (isOpened.get()) {
                    wake.closePort();
                }
            } catch (Throwable t) {
                t.printStackTrace();
                System.exit(-1);
            }
        });
    }

    private void updateControls() {
        openButton.disableProperty().bind(
                Bindings.isNull(numberComboBox.getSelectionModel().selectedItemProperty())
                        .or(baudRateTextField.textProperty().isEqualTo(""))
                        .or(isOpened)
        );
        closeButton.disableProperty().bind(Bindings.not(isOpened));
        bottomPane.disableProperty().bind(Bindings.not(isOpened));
        numberComboBox.disableProperty().bind(isOpened);
        baudRateTextField.disableProperty().bind(isOpened);
        numberLabel.disableProperty().bind(isOpened);
        baudRateLabel.disableProperty().bind(isOpened);
    }

    private void showError(final String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setHeaderText(Messages.DIALOG_ERROR_HEADER);
        alert.setContentText(message);
        alert.showAndWait();
    }

    private int getIntFromTextInputControl(TextInputControl textField) {
        try {
            return Integer.parseInt(textField.getText());
        } catch (NumberFormatException e) {

            textField.selectAll();
            textField.requestFocus();
            String paramName;
            if (textField.getPromptText().length() > 0) {
                paramName = textField.getPromptText();
            } else {
                paramName = textField.getId();
            }

            throw new NumberFormatException(String.format(Messages.STRING_FORMAT_INVALID_PARAMETER, textField.getText(), paramName));
        }
    }

    public void openAction() {
        try {
            outputTextArea.clear();

            int deviceID = Integer.parseInt(numberComboBox.getValue().toString());
            int baudRate = getIntFromTextInputControl(baudRateTextField);

            wake.openPort(deviceID, baudRate);
        } catch (Exception e) {
            showError(e.getMessage());
        }

        isOpened.set(wake.isOpened());
    }

    public void closeAction() {
        try {
            wake.closePort();
        } catch (Exception e) {
            showError(e.getMessage());
        }
        isOpened.set(wake.isOpened());
    }

    public void infoAction() {
        try {
            byte address = (byte) getIntFromTextInputControl(addressTextField);
            int timeOut = getIntFromTextInputControl(timeOutTextField);

            final String name = wake.getInfo(timeOut, address);

            outputTextArea.appendText(String.format(Messages.STRING_FORMAT_RESULT + System.lineSeparator(), name));
        } catch (Exception e) {
            showError(e.getMessage());
        }
    }

    public void echoAction() {
        try {
            byte address = (byte) getIntFromTextInputControl(addressTextField);
            int timeOut = getIntFromTextInputControl(timeOutTextField);
            byte count = (byte) new Random().nextInt(wake.getMaxSizeTx());
            byte[] tx = new byte[Byte.toUnsignedInt(count)];
            new Random().nextBytes(tx);
            byte[] rx = new byte[Byte.toUnsignedInt(wake.getMaxSizeRx())];
            boolean compare = wake.getEcho(timeOut, address, count, tx, rx);

            outputTextArea.appendText(
                    String.format(Messages.STRING_FORMAT_RESULT + System.lineSeparator(), compare ? Messages.STRING_MATCH : Messages.STRING_NOT_MATCH)
            );
        } catch (Exception e) {
            showError(e.getMessage());
        }
    }
}
