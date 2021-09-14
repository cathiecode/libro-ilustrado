/*
 * ゲームに対する入力の状態を簡単に取得するためのクラス
 * ProcessingではキーリピートイベントがそのままkeyPressedに反映されてしまうため、
 * そのまま使っていると連打が容易すぎるほか長押しを判定できないなどある。
 * それを無理やりもとに戻すクラス。
 */
class GameInputHandler {
    private HashMap<Character, KeyState> keys = new HashMap(); // キーと押されてるかどうかの対応表
    private HashMap<Integer, KeyState> buttons = new HashMap(); // マウスボタンと押されたかどうかの対応表
    boolean isMouseMoving = false;

    // keyPressedで呼び出されるべきメソッド
    void handleKeyPressed(char _key) {
        KeyState key_state = keys.get(normalize(_key)); // 現在のキーの状態
        if (key_state == null) { // 一回もキーが押されていない場合
            key_state = new KeyState();
            keys.put(normalize(_key), key_state);
        }
        key_state.handlePressed();
        if (_key == ESC) { // エスケープキーで強制終了されないようにしておく
            key = 0;
        }
    }

    // keyReleasedで呼び出されるべきメソッド
    void handleKeyReleased(char _key) {
        KeyState key_state = keys.get(normalize(_key));
        if (key_state == null) return;
        key_state.handleRelease();
        return;
        
    }

    // キーがおされているかどうかを取得
    boolean key(char _key) { 
        KeyState key_state = keys.get(normalize(_key));
        if (key_state == null) {
            return false;
        }
        return key_state.isPressed();
    }

    boolean keyOneshot(char _key) { // 1フレームだけtrueになってキーリピートなどを無視できるようにしたもの
        KeyState key_state = keys.get(normalize(_key));
        if (key_state == null) {
            return false;
        }
        return key_state.isPressedOneshot();
    }

    // Shift(CapsLock)がオンになっているときに大文字がわたってくるのでそれの処理をするメソッド
    private char normalize(char _key) {
        return Character.toLowerCase(_key);
    }

    void handleMouseMoved() {
        isMouseMoving = true;
    }

    // mousePressedで呼び出されるべきメソッド(内容はhandleKeyPressedと同じ)
    void handleMousePressed(int _mouseButton) {
        KeyState key_state = buttons.get(_mouseButton);
        if (key_state == null) {
            key_state = new KeyState();
            buttons.put(_mouseButton, key_state);
        }
        key_state.handlePressed();
    }

    // mouseReleasedで呼び出されるべきメソッド
    void handleMouseReleased(int _mouseButton) {
        KeyState key_state = buttons.get(_mouseButton);
        if (key_state == null) return;
        key_state.handleRelease();
    }

    // マウスボタンがおされているかどうかを取得
    boolean mouseButton(int _mouseButton) { 
        KeyState key_state = buttons.get(_mouseButton);
        if (key_state == null) {
            return false;
        }
        return key_state.isPressed();
    }

    // keyOneshotと同じ動作をするマウスボタン版
    boolean mouseButtonOneshot(int _mouseButton) {
        KeyState key_state = buttons.get(_mouseButton);
        if (key_state == null) {
            return false;
        }
        return key_state.isPressedOneshot();
    }

    // 毎フレーム呼び出されるべきupdate
    // 注意: draw()の中で使うならisMouseMovingを使いたい処理より後に呼び出すこと。
    void update() {
        isMouseMoving = false;
        for (Character key_state_id: keys.keySet()) {
            keys.get(key_state_id).update();
        }
        for (Integer button_state_id: buttons.keySet()) {
            buttons.get(button_state_id).update();
        }
    }
}

/*
 * 各キーの状態を保存するクラス
 */
class KeyState {
    float release_delay_ms = 50; // 連打の間隔をどれくらい許容するか
    float last_release_time = millis();
    boolean is_pressing = true;
    boolean is_already_oneshot = false; // oneshotがすでに読み取られたかどうか

    void handlePressed() {
        is_pressing = true;
        // 最後に離された時間から十分に時間が経った
        if (millis() - last_release_time > release_delay_ms) {
            is_already_oneshot = false;
        }
    }

    void handleRelease() {
        is_pressing = false;
        last_release_time = millis();
    }

    void update() {
        is_already_oneshot = true;
    }

    boolean isPressed() {
        // 現在進行形で押されている
        if (is_pressing) return true;
        // 離した時からあまり時間がたっていない
        if (millis() - last_release_time < release_delay_ms) return true;
        return false;
    }

    boolean isPressedOneshot() { // 1フレームだけ有効になるisPressed
        if (!isPressed()) return false;
        if (is_already_oneshot) return false;
        return true;
    }
}
