/*
 * チャプターを選択する画面のState
 */
class StageSelectState extends GameState {
    UiManager ui_manager; // ボタン
    UiManager stages_ui_manager;
    ChapterMetaData hovered_chapter_metadata;
    PImage hovered_chapter_background;
    ChapterClearState best_chapter_clear_state = null;
    boolean locked_chapter_hovered = false;

    StageSelectState() {

   }

    void onStateMount() {
        ui_manager = getGameMaster().createUiManager();
        stages_ui_manager = getGameMaster().createUiManager();
        for (int i = 0; i < GameGlobal.chapterCompilation.size(); i++) { // すべてのチャプターについて
            ChapterMetaData chapter_metadata = GameGlobal.chapterCompilation.get(i);
            if (i <= GameGlobal.player_data.unlocked_index) { // アンロックされた分はおせるボタンで
                stages_ui_manager.addClickable(new UiClickableText(str(i), chapter_metadata.title, 430, 400 + i * 48, GameGlobal.default_font_style));
            } else { // アンロックされてない分は押せないボタンで
                stages_ui_manager.addClickable(new UiClickableImage("locked", "assets/locked.png", 430, 400 + i * 48 ));
            }
        }
        // 戻るボタン
        ui_manager.addClickable(new BookmarkButton("title", "タイトルへ", 140, height - 75, "blue"));
        // 0ページを開く
        GameGlobal.background.openPage(0);
    }

    void update(float time_delta_ms) {
        String ui_clicked = ui_manager.check_clicked(); // 押されたボタンは…
        if (ui_clicked == "title") { // 戻るボタンが押された
            getGameMaster().replaceState(new Title());
            return;
        }
        String hovered_chapter_index_string  = stages_ui_manager.check_hovered(); // マウスホバーされたステージが…
        if (hovered_chapter_index_string != "" && hovered_chapter_index_string != "locked") { // なにかがマウスホバーされている場合
            int index = int(hovered_chapter_index_string);
            hovered_chapter_metadata = GameGlobal.chapterCompilation.get(index);
            best_chapter_clear_state = GameGlobal.player_data.getBestChapterClearState(hovered_chapter_metadata.chapter_number);
            if (best_chapter_clear_state != null) {
                hovered_chapter_background = AssetLoader.image(hovered_chapter_metadata.background_path);
            } else {
                hovered_chapter_background = loadImage(hovered_chapter_metadata.background_path);
                hovered_chapter_background.filter(GRAY);
            }
        }
        if (hovered_chapter_index_string == "locked") {
            hovered_chapter_metadata = null;
            locked_chapter_hovered = true;
        }

        String selected_chapter_index_string = stages_ui_manager.check_clicked(); // 押されたボタンは…

        if (selected_chapter_index_string == "locked") { // ロックされているやつ
            getGameMaster().pushState(new MessageBox("ロックされています!"));
            return;
        }
        if (selected_chapter_index_string != "") { // それ以外(有効なステージ)
            int index = int(selected_chapter_index_string);
            getGameMaster().replaceState(new SkillSelect(GameGlobal.chapterCompilation.get(index)));
            return;
        }
    }

    void render() {
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        textSize(48);
        text("目次", 430, 200);
        if (hovered_chapter_metadata != null) {
            tint(255, 192);
            image(hovered_chapter_background, 800, 87, 463, 786);
            noTint();
            text(hovered_chapter_metadata.title, 950, 750);

            fill(#000000, 128);
            rect(850, 300, 400, 300);
            GameGlobal.default_font_style.apply();
            fill(#ffffff);
            if (best_chapter_clear_state != null) {
                text("クリアランク: " + best_chapter_clear_state.rank.rank_string, 900, 350);
                text("クリアタイム: " + timeMsToBePretty(best_chapter_clear_state.clear_time_ms), 900, 398);
            } else {
                text("まだクリアしていません！", 925, 450);
            }
        } else if (locked_chapter_hovered) {            
            image(AssetLoader.image("assets/bgs/locked.png"), 800, 87, 463, 786);
        }
        ui_manager.render(); // UIのレンダリング
        stages_ui_manager.render();
    }
}
