/*
 * 基本的なロジックを実装するBreakoutにかぶせてLibre ilustorado独自のシステムを実装するクラス。
 */
class CustomBreakout extends Breakout implements EventListener<BreakoutEvent> {
    // 設定用
    float regen_skill_cost_per_ms = 0.0001; // スキルポイントリジェネの速度(スキルポイント毎ミリ秒)
    float max_skill_cost          = 10;    // スキルポイントの上限

    // スキルを実現するためのフィールド群
    SkillDeck skill_deck; // SkillFactoryをいれておく配列
    EntityManager<Skill> running_skill = new EntityManager(); // 実行中のスキルを入れておく配列

    float available_skill_cost = 0.0; // 現在使用可能なスキルコスト
    float time_scale_ratio = 1.0;     // 実時間に対するゲーム内時間の比率。0.1=遅い、10.0=早い
    float lifetime_ms = 0;            // ゲームロジックの実行時間。time_scale_ratioの影響を受ける。
    boolean skill_commit = false;     // スキル発動画面で発動が指示された場合true
    SkillFactory selecting_skill = null; // 選択中のスキル

    // 演出まわり
    GameAudio audio;
    AnimationManager animation_manager = new AnimationManager(); // アニメーション
    PImage sticker_card; // 枠
    float vibration_power = 0; // 振動の振幅
    float vibration_power_half_life_ms = 100; // 振幅の半減期
    FontStyle skill_cost_message_font_style; // スキルコストが足りないときのメッセージのフォント
    float skill_cost_warn_start_ms = -10000; // スキルコストが足りないときのメッセージがいつ発せられたかを示す変数
    PImage ink; // スキルコストを表す画像
    PImage player_image; // 平たく言うとラケットの画像
    

    // NOTE: マジックナンバーはフレームの画像から
    float frame_x = 78;
    float frame_y = 110;

    float pointer_x, pointer_y; // 相対マウス座標

    CustomBreakout(SkillDeck _skil_deck, float width, float height) {
        super(width, height, 10, new BreakoutPaddle(width / 2, height * 0.85, width * 0.1, width * 0.1 * 0.03 , INVISIBLE_STYLED_RECT));
        registListener(this);
        try {
            skill_cost_message_font_style = GameGlobal.default_font_style.clone(); // スキルコスト不足メッセージのフォントを適用
            skill_cost_message_font_style.setColor(#ffffff); // スキルコスト不足メッセージのいろを設定
        } catch(Exception e) {
            println("CustomBreakout: Failed to clone font style");
        }
        sticker_card = AssetLoader.image("assets/sticker_card.png");
        ink = AssetLoader.image("assets/ink.png");
        player_image = AssetLoader.image("assets/player.png");
        skill_deck = _skil_deck;
    }

    void toggleSkillMode(int number) { // スキルボタンが押されたらここへ
        if (selecting_skill == null) { // スキルが選択されていなかったらスキルモードを開始
            startSkillMode(number);
        } else {
            exitSkillMode(); // スキルが選択されていたらキャンセル
        }
    }

    void startSkillMode(int number) { // スキルモードを始めるやつ
        skill_commit = false;
        try {
            selecting_skill = skill_deck.get(number); // 要求されたスキルを選択する
            changeTimeScale(0.25); // スキルモード中は速度が遅くなる
        } catch(IndexOutOfBoundsException e) {
            selecting_skill = null;
        }
    }

    void exitSkillMode() { // スキルモードを抜けるやつ
        resumeTimeScale(0.25); // 速度をもとに戻す
        selecting_skill = null;
        skill_commit = false;
    }

    boolean tryConsumeSkillCost(float amount) { // 要求されたスキルコストがあれば消費してtrue、なければfalse
        if (available_skill_cost < amount) {
            return false;
        }
        available_skill_cost -= amount;
        return true;
    }

    void updateSkillCost(float time_delta_ms) { // スキルコストのリジェネ(毎フレーム)
        addSkillCost(regen_skill_cost_per_ms * time_delta_ms);
    }

    void addSkillCost(float cost) {
        available_skill_cost += cost;
        if (available_skill_cost > max_skill_cost) {
            available_skill_cost = max_skill_cost;
        }
    }

    // 時間の速さを変える。1.0を基準として0.0<ratio<∞の間で変えられる
    void changeTimeScale(float ratio) {
        time_scale_ratio = time_scale_ratio * ratio;
    }

    // 時間の速さを戻す。changeTimeScaleと同じAPIで呼び出せるようにしただけ。
    void resumeTimeScale(float ratio) {
        time_scale_ratio = time_scale_ratio / ratio;
    }

    void update(float time_delta_ms, float pointer_x, float pointer_y) {
        // ポインタの座標がステージ内に収まるように保証する
        this.pointer_x = constrain(pointer_x, 0, stage_width);
        this.pointer_y = constrain(pointer_y, 0, stage_height);

        // 画面の振動をほどよく抑える(半減期の式をつかっている)
        vibration_power = vibration_power * pow(0.5, time_delta_ms / vibration_power_half_life_ms);

        // スキルコストを更新
        updateSkillCost(time_delta_ms * time_scale_ratio);

        // スキルモードの場合更新
        updateSkillMode(time_delta_ms);

        // 発動中のスキルを更新
        for (Skill skill: running_skill) {
            skill.update(time_delta_ms * time_scale_ratio);
        }
        // 終わったスキルを消したり
        running_skill.applyPendingModifications();

        // アニメーションを更新
        animation_manager.update(time_delta_ms * time_scale_ratio);

        // Breakoutのコアの処理を更新
        super.update(time_delta_ms * time_scale_ratio);

        lifetime_ms += time_delta_ms * time_scale_ratio;
    }

    void commitSkill() { // スキルを確定した場合に呼び出される
        skill_commit = true;
    }
    
    // スキルモードの更新
    void updateSkillMode(float time_delta_ms) {
        if (selecting_skill == null) return; // 選択中のスキルがなければ終わっておく
        if (skill_commit) { // スキルの発動が確定されたら
            if (tryConsumeSkillCost(selecting_skill.cost())) { // コストがあれば消費して実行
                running_skill.add(selecting_skill.createSkill(this, pointer_x, pointer_y)); // スキルを発動
                exitSkillMode(); // スキルモードを抜ける
            } else {
                // スキルコストが足りなかった場合
                skill_cost_warn_start_ms = lifetime_ms; // スキルコストが足りない旨を表示する
                skill_commit = false; // 確定できないのでやりなおさせる
            }
        }
    }

    // スキルモードのレンダリング
    void renderSkillMode(float _x, float _y) {
        if (selecting_skill == null) return; // 選択中のスキルがなければ抜ける
        pushMatrix();
            translate(_x, _y);
            noStroke();
            fill(#000000, 128);
            rect(0, 0, stage_width, stage_height); // ちょっと暗くする

            GameGlobal.default_font_style.apply();
            textAlign(LEFT, TOP);

            fill(#ffffff);
            text(selecting_skill.skillTitle(), 0, 16); // スキルタイトル

            textSize(24);
            text(selecting_skill.skillDescription(), 0, 48); // スキルの説明

            text("スキルコスト: " + nf(selecting_skill.cost(), 2, 2) + " / " + nf(available_skill_cost, 2, 2) + " (Max:" + max_skill_cost + ")", 0, 80); // スキルコスト

            if (selecting_skill.cost() <= available_skill_cost) {
                fill(#0000ff, 128);
                stroke(#0000ff, 192);
            } else {
                fill(#aa0000, 128);
                stroke(#aa0000, 192);
            }
            selecting_skill.renderSkillPreview(this, pointer_x, pointer_y); // 選ばれているスキル固有の描画
        popMatrix();
    }

    void reCastBall() {
        castBall(new NormalBall(stage_width / 2, paddle.y - 100, this)); // ボールの再投げ込み
    }

    void init(GameMaster master) { // リセット
        this.audio = master.audio;
        this.audio.loadSE("audio/se/pa.mp3");

        time_scale_ratio = 1.0;
    }

    // レンダリング(_x, _yはオフセット)
    void render(float _x, float _y) {
        float vibration_x = random(-1, 1) * vibration_power; // 振動してるときのブレを計算しておく
        float vibration_y = random(-1, 1) * vibration_power;

        float offset_x = _x + vibration_x;
        float offset_y = _y + vibration_y;

        strokeWeight(2);
        stroke(#333355);
        noFill();
        rect(_x, _y, stage_width, stage_height);

        super.render(offset_x, offset_y);                                       // ゲーム本体のレンダリング
        
        // プレイヤーの画像(ラケットの画像)を描画
        image(player_image,
            offset_x + paddle.x - paddle.width / 2,
            offset_y + paddle.y - paddle.height / 2,
            paddle.width,
            paddle.width / player_image.width * player_image.height
        );
        animation_manager.render(_x, _y);                           // アニメーションのレンダリング
        renderSkillMode(_x, _y); // スキルモードの描画

        stroke(#1c1010);
        fill(#f2f2f2);
        image(sticker_card, _x + stage_width + 310 - 250 + 5, _y + stage_height - 50 - 100, 500, 200);


        renderDeck(_x + stage_width + 200, _y + stage_height - 100); // デッキ画像のレンダリング
        
        // スキルコスト警告がまだ必要なら描画
        if (lifetime_ms - skill_cost_warn_start_ms <= 1000) {
            skill_cost_message_font_style.apply();
            textAlign(CENTER, CENTER);
            text("スキルコストが足りません！", _x + stage_width / 2, _y + stage_height / 2 + 120);
        }

        GameGlobal.default_font_style.apply();
        textAlign(CENTER, TOP);
        if (selecting_skill != null) {
            if (selecting_skill.cost() > available_skill_cost) {
                fill(#cc0000);
            } else {
                fill(#00cc00);
            }
            text(nfs(available_skill_cost - selecting_skill.cost(), 0, 1), _x + stage_width + 80 + 18 + 32, _y + stage_height - 100 + 80); // スキルコストの数値描画
        } else {
            text(nfs(available_skill_cost, 0, 1), _x + stage_width + 80 + 18 + 32, _y + stage_height - 100 + 80); // スキルコストの数値描画
        }
        
        image(ink, _x + stage_width + 80 + 18, _y + stage_height - 100, 64, 64);
        for (int i = 1; i <= available_skill_cost; i++) { // スキルコストのアイコン描画
            //image(ink, (i - 1) * 32 + offset_x, stage_height - 32 + offset_y, 32, 32);
        }
    }

    // スキルデッキの描画
    void renderDeck(float origin_x, float origin_y) {
        float x = origin_x;
        float y = origin_y;

        for (SkillFactory skill: skill_deck) {
            if (skill.cost() > available_skill_cost) {
                tint(64);
            }
            if (selecting_skill == skill) {
                if (skill.cost() <= available_skill_cost) {
                    tint(205 + sin(lifetime_ms / 250 * TWO_PI) * 50);
                }
                skill.icon().render(x, y - 30, 100, 100);
            } else {
                skill.icon().render(x, y, 100, 100);
            }
            noTint();
            x += 120; // よこにずらしながらひとつづつ
        }
    }

    // ブロックが壊されたときに呼び出されるので、それを利用してアニメーションのひとつでも。
    void block_broke(BreakoutBlock block) {
        this.audio.playSE("audio/se/pa.mp3");
        super.block_broke(block);
        // 水しぶきのアニメーションを追加する
        for (int i = 0; i < 10; i++) {
            float angle0 = (random(0, PI) + PI); // 上方向の180度のどこかに投げる
            float speed = block.width / 1000; // 速度とかは適当
            float size = block.height / 10;
            float offset_x = random(block.width) + block.x - block.width / 2; // ブロックのどこかから出るようにランダムを調整
            float offset_y = random(block.height) + block.y - block.height / 2;
            Particle particle = new Particle(offset_x, offset_y, speed * cos(angle0), speed * sin(angle0), size, 500, #333333);
            particle.setGravity(0, block.height / 100000); // たぶん丁度いい重力を追加しておく
    
            animation_manager.add(particle);
        }
    }

    // 振動演出が必要なときに呼び出すと震えるメソッド
    void addVibration(float power) {
        vibration_power += power;
    }

    void receive(BreakoutEvent event) {
        switch(event) {
            case BLOCK_BALL_DAMAGE:
                addSkillCost(1.0);
                break;
        }
    }
}
