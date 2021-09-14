/*
 * ゲームのポーズ画面。
 */ 
class PauseState extends GameState {
    UiManager ui_manager;
    String selected_menu;
    float lifetime_ms = 0;

    void onStateMount() {
        lifetime_ms = 0;
        ui_manager = getGameMaster().createUiManager();
        ui_manager.addClickable(new BookmarkButton("restart",  "やりなおす", 990, 290, "red"));
        ui_manager.addClickable(new BookmarkButton("skill",    "スキル選択", 990, 410, "red"));
        ui_manager.addClickable(new BookmarkButton("index",    "目次に戻る", 990, 530, "red"));
        ui_manager.addClickable(new BookmarkButton("continue", "つづける",   990, 650, "green"));
    }

    void update(float time_delta_ms) {
        if (getGameMaster().input.keyOneshot(ESC) && lifetime_ms != 0) {
            getGameMaster().popState();
        }

        if (ui_manager.check_clicked() != "") {
            println("clicked:", ui_manager.check_clicked());
            selected_menu = ui_manager.check_clicked();
            getGameMaster().popState();
        }
        lifetime_ms += time_delta_ms;
    }

    void render() {
        image(AssetLoader.image("assets/page.png"), 860, 220, 367, 480);
        ui_manager.render(); // UIのレンダリング
    }
}
