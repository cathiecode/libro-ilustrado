/*
 * チャプターのクリア演出のState
 */
class LevelResultClear extends GameState {
    float lifetime_ms = 0;
    LevelState level_state; // レベルのクリア状況を保持
    AnimationManager animation_manager = new AnimationManager();
    LevelResultClear(LevelState level_state) {
        this.level_state = level_state;
        try {
            // ぽよぽよ動く文字を追加
            animation_manager.add(new PoyonText1("CLEAR!", 350, height / 2, GameGlobal.default_font_style.clone().setColor(#66cc66), 2000));
        } catch(Exception e) {
            println("LevelResultClear: CloneNotSupportedException thrown"); // HACK: 真面目に例外処理してる時間がない！握りつぶしてログだけ残しとく
        }
    }

    void onStateMount() {
        GameGlobal.player_data.storeChapterClear(this.level_state);
        // クリアしたステージが一番新しいステージだったらセーブデータを更新
        if (level_state.chapter_data.chapter_number >= GameGlobal.player_data.unlocked_index) {
            GameGlobal.player_data.unlocked_index = level_state.chapter_data.chapter_number + 1;
        }
        savePlayerData(GameGlobal.player_data);
    }

    void update(float time_delta_ms) {
        getGameMaster().audio.setBgmVolume(max(0, 1.0 - lifetime_ms / 3000));
        if (lifetime_ms >= 5000) {
            getGameMaster().popState(); // このStateを破棄して…
            getGameMaster().replaceState(new LevelResult(level_state)); // 下のStateも入れ替える
        }
        animation_manager.update(time_delta_ms);
        lifetime_ms += time_delta_ms;
    }

    void render() {
        GameGlobal.default_font_style.apply();
        animation_manager.render(0, 0);
    }
}
