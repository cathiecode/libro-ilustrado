import java.util.Iterator;

/*
 * CustomBreakoutをつかって実際のゲーム画面を構成するクラス。
 */
class Level extends GameState implements EventListener<BreakoutEvent> {
    CustomBreakout break_out; // 本体
    GameInputHandler input;   // インプットハンドラ
    Iterator<LevelData> current_level; // 現在のチャプター内レベルのポインタ
    SkillDeck skill_deck; // スキルデッキ
    LevelState level_state = new LevelState(); // スコアなどの状態
    OneshotTimer wave_change_timer = new OneshotTimer(1000); // チャプター内レベルの遷移をちょっと遅らせるためのタイマー
    int wave_number = 0; // 現在のウェーブ数
    BlendedGrayImage background;
    float background_gray_ratio = 1.0;
    PauseState pause_state = new PauseState();
    
    // NOTE: マジックナンバーは画面の位置
    float playarea_x = 150;
    float playarea_y = 87;

    Level(ChapterData chapter_data, SkillDeck skill_deck) {
        this.current_level = chapter_data.iterator(); // 最初のレベルを読み込んでおく

        this.level_state.chapter_data = chapter_data;
        this.level_state.limit_time_ms = 3 /* min is */ * 60 /* sec and is */  * 1000 /*ms*/; // 制限時間。とりあえず3分固定で…
        this.skill_deck = skill_deck;
        this.background = new BlendedGrayImage(chapter_data.background);
    }

    void onStateMount() {
        init();
        GameGlobal.background.nextPage(); // とりあえずここにきたら1枚めくっておく
        getGameMaster().pushState(new LevelOpening()); // 開始演出を呼び出しておく
    }

    // 初期化
    void init() {
        getGameMaster().audio.playBgm(level_state.chapter_data.audio);
        break_out = new CustomBreakout(skill_deck, 493, 786);

        break_out.registListener(this); // 自分自身をイベントリスナとして追加してイベントを聴く
        break_out.init(getGameMaster()); // ゲームマスターが必要なのでいっしょにinitしておく
        spawnLevel(current_level.next()); // ステージを配置しておく
    }

    // レベルをクリアしてセットアップしなおす
    void spawnLevel(LevelData level) {
        break_out.balls.clear(); // ボールを消す
        break_out.running_skill.clear(); // スキルを消す
        break_out.reCastBall(); // ボールを投げ直す
        spawnBreakoutBlock(break_out, level); // ブロックを作成する
    }

    void onBecameTop() { // LevelOpening終了時に来る
        if (pause) {
            println("return");
            processPauseMenu(pause_state.selected_menu);
            pause = false;
        }
    }

    void processPauseMenu(String selected) {
        if (selected == null) {
            return;
        }
        switch(selected) {
            case "restart":
                getGameMaster().replaceState(new ChapterLoading(level_state.chapter_data.meta_data, skill_deck));
                break;
            case "skill":
                getGameMaster().replaceState(new SkillSelect(level_state.chapter_data.meta_data));
                break;
            case "index":
                getGameMaster().replaceState(new StageSelectState()); // TODO
                break;
            case "continue":
                // do nothing
                break;
        }
    }

    // ポーズ状態かどうか
    boolean pause;

    void update(float time_delta_ms, boolean is_top) {
        if (getGameMaster().input.keyOneshot(ESC) && is_top) { // エスケープで一時停止
            pause = true;
            getGameMaster().pushState(pause_state);
        }
        if (pause) return;

        handleInput(time_delta_ms); // 入力を反映する
        break_out.update(time_delta_ms, mouseX - playarea_x, mouseY - playarea_y); // 本体の更新
        this.level_state.setPlaytime(break_out.lifetime_ms);
        if (this.level_state.failed) {
            failed();
        }
        if (wave_change_timer.check(time_delta_ms)) { // ウェーブ終了後一定時間で次ウェーブに移行
            spawnLevel(current_level.next()); // ブロックを出現させる
            GameGlobal.background.nextPage(); // ページを次へ
            break_out.resumeTimeScale(0.5); // 遅くなってたのを解除
            wave_number++; // ウェーブ数をインクリメント
        }
        if (this.level_state.cleared) {
            background_gray_ratio -= time_delta_ms * 0.0005;
            if (background_gray_ratio < 0) {
                background_gray_ratio = 0;
            }
        }
    }

    void render() {
        this.background.render(playarea_x, playarea_y, break_out.stage_width, break_out.stage_height, background_gray_ratio);
        /*if (!this.level_state.cleared) {
            fill(0, 0, 0, (1.0 - this.level_state.remainTimeMs() / this.level_state.limit_time_ms) * 255.0);
            rect(playarea_x, playarea_y, break_out.stage_width, break_out.stage_height);
        }*/
        break_out.render(playarea_x, playarea_y); // 本体のレンダリング
        GameGlobal.default_font_style.apply();
        textSize(32);
        // ウェーブ数表示
        text("wave: " + (wave_number + 1) + "/" + (this.level_state.chapter_data.size()), 860, height / 2 - 48 * 2);
        // タイマー表示
        if (this.level_state.cleared) {
            // クリア時は赤く表示
            fill(#ff3333);
            text(timeMsToBePretty(this.level_state.remainTimeMs()), 860, height / 2);
        } else {
            text(timeMsToBePretty(this.level_state.remainTimeMs()), 860, height / 2);
        }
    }

    void handleInput(float time_delta_ms) {
        break_out.paddle.setPos(mouseX - playarea_x, break_out.paddle.y);
        if (game_master.input.keyOneshot('1')) {
            break_out.toggleSkillMode(0);
        }
        if (game_master.input.keyOneshot('2')) {
            break_out.toggleSkillMode(1);
        }
        if (game_master.input.keyOneshot('3')) {
            break_out.toggleSkillMode(2);
        }
        if (mousePressed) {
            break_out.commitSkill();
        }
    }

    void receive(BreakoutEvent event) {
        switch (event) {
            case BALL_FELL:
                break;

            case PERFECT:
                perfect();
                break;

            case BROKE:
                break;
            case PADDLE_TOUCHED:
                break;
        }
    }

    void receive(String pause_result) {

    }

    void perfect() {
        if (current_level.hasNext()) {
            wave_change_timer.start();
            break_out.changeTimeScale(0.5);
        } else {
            if (this.already_failed) return;
            this.level_state.clear(break_out.lifetime_ms);
            break_out.changeTimeScale(0.25);
            getGameMaster().pushState(new LevelResultClear(level_state));
        }
    }

    boolean already_failed = false;

    void failed() {
        if (already_failed) return;
        already_failed = true;
        break_out.changeTimeScale(0.25);
        getGameMaster().pushState(new LevelResultFailed(level_state));
    }
}
