/*
 * チャプターの失敗演出のState
 */
class LevelResultFailed extends GameState {
    float lifetime_ms = 0;
    LevelState level_state; // レベルのクリア状況を保持
    AnimationManager animation_manager = new AnimationManager();
    LevelResultFailed(LevelState level_state) {
        this.level_state = level_state;
        try {
            // ぽよぽよ動く文字を追加
            animation_manager.add(new PoyonText1("FAILED...", 320, height / 2, GameGlobal.default_font_style.clone().setColor(#cc6666), 2000));
        } catch(Exception e) {
            println("LevelResultClear: CloneNotSupportedException thrown"); // HACK: 真面目に例外処理してる時間がない！握りつぶしてログだけ残しとく
        }
    }

    void update(float time_delta_ms) {
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
