/*
 * メッセージボックス（お知らせ用）です。
 */
class MessageBox extends GameState {
    String message; // 表示するメッセージ
    UiManager ui_manager; // ボタン用のコンテナ

    MessageBox(String message) {
        this.message = message;
    }

    void onStateMount() {
        ui_manager = getGameMaster().createUiManager();
        // ボタンを追加
        ui_manager.addClickable(new UiClickableText("ok", "OK", width / 2, height / 2 + 100, GameGlobal.default_font_style));
    }

    void update(float time_delta_ms) {
        // ボタンが押されたら終わる
        if (ui_manager.check_clicked() == "ok") {
            getGameMaster().popState();
        }
    }

    void render() {
        noStroke();
        fill(#cccccc);
        rect(width / 2 - 200, height / 2 - 150, 400, 300); // ボックス
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        text(message, width / 2, height / 2); // テキストを表示
        ui_manager.render(); // ボタンの表示
    }
}
