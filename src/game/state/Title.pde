/*
 * ゲームのタイトル画面。
 */ 
class Title extends GameState {
    UiManager ui_manager;
    PImage card;
    boolean first_render = false;

    Title() {
        card = AssetLoader.image("assets/ui/card.png");
    }

    Title(boolean first_render) {
        card = AssetLoader.image("assets/ui/card.png");
        this.first_render = first_render;
    }

    void onStateMount() {
        ui_manager = getGameMaster().createUiManager();
        ui_manager.addClickable(new BookmarkButton("start", "ストーリー",       230, 300, "green"));
        ui_manager.addClickable(new BookmarkButton("instruction", "あそびかた", 230, 400, "blue"));
        ui_manager.addClickable(new BookmarkButton("instruction_c", "そうさ",     230, 500, "blue"));
        ui_manager.addClickable(new BookmarkButton("credit", "クレジット",      230, 600, "blue"));
        ui_manager.addClickable(new BookmarkButton("exit", "やめる",            230, 700, "red"));
        if (!this.first_render) {
            GameGlobal.background.closeToHead(); // 閉じた状態でスタート
        }
        this.first_render = false;
        getGameMaster().audio.playBgm("audio/bgm/c19.mp3");
    }

    void onBecameTop() {
    }

    void update(float time_delta_ms) {
        switch (ui_manager.check_clicked()) {
            case "start":
                game_master.replaceState(new StageSelectState()); // チャプターセレクトへ
                break;
            case "instruction":
                game_master.replaceState(new ShowImageState(this, AssetLoader.image("assets/howto.png")));
                break;
            case "instruction_c":
                game_master.replaceState(new ShowImageState(this, AssetLoader.image("assets/instruction.png")));
                break;
            case "credit":
                game_master.replaceState(new ShowImageState(this, AssetLoader.image("assets/credit.png")));
                break;
            case "exit":
                game_master.replaceState(new FadeOut(new Exit())); // 終了
                break;
        }
    }
    void render() {
        image(card, 90, 90);
        ui_manager.render(); // UIのレンダリング
    }
}
