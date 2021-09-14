/*
 * チャプター終了時の演出State
 */
class LevelResult extends GameState {
    GameState title          = new Title(); // タイトル画面
    GameState chapter_select = new StageSelectState(); // チャプターセレクト画面
    UiManager ui_manager; // ボタンのコンテナ

    float lifetime_ms = 0;
    LevelState level_state;

    LevelResult(LevelState level_state) {
        this.level_state = level_state;
    }

    void onStateMount() {
        GameGlobal.background.nextPage(); // ページ繰り演出

        ui_manager = getGameMaster().createUiManager(); // UIコンテナ
        ui_manager.addClickable(new BookmarkButton("chapter", "つづける",   430 + 192, height * 0.8, "green")); // 右
        ui_manager.addClickable(new BookmarkButton("title",  "タイトルへ", 430 - 192, height * 0.8, "blue"));   // 左
        if (level_state.cleared) {
            getGameMaster().audio.playBgm("audio/bgm/n113.mp3");
        }
    }

    void update(float time_delta_ms) {
        switch (ui_manager.check_clicked()) { // ボタンがクリックされていたら
            case "title":
                game_master.replaceState(title); // タイトルにもどる
                break;
            case "chapter":
                game_master.replaceState(chapter_select); // チャプター選択に戻る
                break;
        }

        lifetime_ms += time_delta_ms;
    }

    void render() {
        if (level_state.cleared) {
            image(AssetLoader.image(level_state.chapter_data.background), 150, 87, 493, 786);
        }

        noStroke();
        fill(#ffffff, 128);
        rect(110, 60, 630, 840); // 750, 910

        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        textSize(48);
        if (level_state.cleared) { // チャプターのクリア状況で分岐
            text("CHAPTER CLEAR!", 430, 150);
        } else {
            text("CHAPTER FAILED...", 430, 150);
        }

        textSize(32);
        text("チャプター: " + level_state.chapter_data.title, 430, height / 2 - 48);
        if (level_state.cleared) {
            text("タイム: " + timeMsToBePretty(level_state.remainTimeMs()), 430, height / 2);
        }
        text("評価: " + getRankByLevelState(level_state), 430, height / 2 + 48);

        if (lifetime_ms >= 3000) { // 一定時間経過後にボタンを出現させる
            ui_manager.render();
        }
    }
}
