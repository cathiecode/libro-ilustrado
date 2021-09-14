/*
 * Yes/Noな質問をなげかけるダイアログ
 */
class YesNoDialog extends GameState {
    GameState yes;
    GameState no;

    String question;
    UiManager ui_manager;

    YesNoDialog(String yes_no_question, GameState _yes, GameState _no) {
        question = yes_no_question;
        yes = _yes;
        no  = _no;
    }

    void onStateMount() {
        GameGlobal.background.nextPage(); // ページを繰る
        ui_manager = getGameMaster().createUiManager();
        ui_manager.addClickable(new BookmarkButton("yes", "はじめる",   430 + 192, height * 0.8, "green"));
        ui_manager.addClickable(new BookmarkButton("no",  "やりなおす", 430 - 192, height * 0.8, "red"));
    }

    void update(float time_delta_ms) {
        switch (ui_manager.check_clicked()) { // 対応するStateにreplaceする
            case "yes":
                game_master.replaceState(yes);
                break;
            case "no":
                game_master.replaceState(no);
                break;
        }
        return;
    }

    void render() {
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, TOP);
        text(question, 430, height * 0.4); // 質問を表示
        ui_manager.render();
    }
}
