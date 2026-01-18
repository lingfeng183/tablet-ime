package com.tabletkeyboard.tablet_ime;

import android.inputmethodservice.InputMethodService;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;

public class TabletInputMethodService extends InputMethodService {

    private InputConnection inputConnection;

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public View onCreateInputView() {
        // Return a simple view for the IME
        View view = new View(this);
        return view;
    }

    @Override
    public void onStartInput(EditorInfo attribute, boolean restarting) {
        super.onStartInput(attribute, restarting);
        inputConnection = getCurrentInputConnection();
    }

    @Override
    public void onStartInputView(EditorInfo info, boolean restarting) {
        super.onStartInputView(info, restarting);
        inputConnection = getCurrentInputConnection();
    }

    public void sendText(String text) {
        if (inputConnection != null) {
            inputConnection.commitText(text, 1);
        }
    }

    public void deleteText() {
        if (inputConnection != null) {
            inputConnection.deleteSurroundingText(1, 0);
        }
    }

    public void sendKeyEvent(int keyCode, boolean isDown) {
        if (inputConnection != null) {
            inputConnection.sendKeyEvent(new KeyEvent(
                isDown ? KeyEvent.ACTION_DOWN : KeyEvent.ACTION_UP,
                keyCode
            ));
        }
    }

    public void commitText(String text) {
        if (inputConnection != null) {
            inputConnection.commitText(text, 1);
        }
    }
}
