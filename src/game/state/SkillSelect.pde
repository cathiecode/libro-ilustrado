/*
 * スキルの選択画面
 */
class SkillSelect extends GameState {
    SkillDeck skill_deck = new SkillDeck(); // 触るスキルデッキ
    UiManager skill_button; // スキルの名前が出るボタンのコンテナ
    UiManager ui_manager; // その他のUi用のコンテナ
    ChapterMetaData chapter; // これから向かうチャプター
    float lifetime_ms = 0;

    /* スキルデモ関連 */
    SkillFactory hovered_skill_factory = null; // マウスホバーされたスキル
    CustomBreakout demo_breakout;              // デモ用の仮の画面
    String prev_hovered_skill_id = "";         // ホバーされたスキルのID

    SkillSelect(ChapterMetaData chapter) {
        this.chapter = chapter;
    }

    void onStateMount() {
        skill_button = getGameMaster().createUiManager();
        ui_manager = getGameMaster().createUiManager();
        GameGlobal.background.openPage(1); // 1ページに行く
        float offset_x = width * 3.0 / 4.0; // スキルボタンの中心X座標
        float offset_y = 200; // スキルボタンの開始Y座標
        for (SkillFactory skill: GameGlobal.skill_registory.skill_by_order) {
            String skill_id = GameGlobal.skill_registory.getIdBySkillFactory(skill);
            // スキルボタンを追加
            skill_button.addClickable(new UiClickableText(skill_id, skill.skillShortDescription(), offset_x, offset_y, GameGlobal.default_font_style));
            offset_y += 48; // ずらす
        }
        // 戻るボタン
        ui_manager.addClickable(new BookmarkButton("stage_select", "目次へ", 140, height - 75, "green"));
    }

    void update(float time_delta_ms) {
        String hovered = skill_button.check_hovered(); // ホバーされているスキルのIDを取得
        if (!hovered.equals("") && !hovered.equals(prev_hovered_skill_id)) { // スキルのIDが変わっていたら…
            hovered_skill_factory = GameGlobal.skill_registory.getSkillFactoryById(hovered); // スキルファクトリーをもらってくる
            SkillDeck demo_skilldeck = new SkillDeck(); // デモ用のスキルデッキを容易しておく
            demo_skilldeck.add(hovered_skill_factory); // デモ用のスキルデッキにホバーされたスキルを入れておく
            demo_breakout = new CustomBreakout(demo_skilldeck, 493, 786); // デモ用の画面を再生成する
            demo_breakout.init(getGameMaster());
            demo_breakout.available_skill_cost = demo_breakout.max_skill_cost; // スキルコストをさいしょからMAXにしておく
            demo_breakout.toggleSkillMode(0); // スキルモードに切り替えておく
            demo_breakout.commitSkill(); // スキルを発動させる
            prev_hovered_skill_id = hovered; // 連続して初期化しないようにする
        }
        String clicked = skill_button.check_clicked(); //  クリックされたスキル
        if (clicked != "") { // クリックされていたら
            SkillFactory skill_factory = GameGlobal.skill_registory.getSkillFactoryById(clicked); // スキルファクトリーを容易
            if (skill_deck.contains(skill_factory)) return; // もう入っていたら入れられない
            skill_deck.add(skill_factory); // スキルデッキにスキルを入れておく
            if (skill_deck.size() >= 3) { // スキルが揃ったらチャプターをスタートさせる
                startChapter();
            }
        }
        if (ui_manager.check_clicked() == "stage_select") { // 戻るボタン
            getGameMaster().replaceState(new StageSelectState());
        }
        if (demo_breakout != null) { // デモが再生されていたらアップデート
            demo_breakout.update(time_delta_ms, demo_breakout.stage_width / 2, demo_breakout.stage_height / 2);
        }
        lifetime_ms += time_delta_ms;
    }

    void render() {
        float list_x = 430;

        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        fill(#000000, sin(lifetime_ms / 250 * PI) * 100 + 155);
        text(skill_deck.size() + 1 + "つめのスキルシールを選択", list_x, 150);
        fill(#000000);

        if (hovered_skill_factory != null) {
            text(hovered_skill_factory.skillTitle(), list_x, 200);
            textSize(24);
            text(hovered_skill_factory.skillDescription(), list_x, 250);
            text("消費スキルコスト: " + int(hovered_skill_factory.cost()), list_x, 280);
        }

        if (demo_breakout != null) { // デモが再生されていたら表示
            float ratio = 400.0 / 786;
            pushMatrix();
                stroke(#333333);
                noFill();
                translate(list_x - ratio * demo_breakout.stage_width / 2, 310);
                scale(ratio);
                rect(0, 0, 493, 786); // 枠線
                demo_breakout.render(0, 0); // デモ本体の描画
            popMatrix();
        }

        float list_y = 710; // リストの開始Y座標

        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        if (skill_deck.size() >= 1) text(skill_deck.get(0).skillShortDescription(), list_x, list_y +  48);
        if (skill_deck.size() >= 2) text(skill_deck.get(1).skillShortDescription(), list_x, list_y +  96);
        if (skill_deck.size() >= 3) text(skill_deck.get(2).skillShortDescription(), list_x, list_y + 144);
        skill_button.render(); // スキル選択ボタンのレンダリング
        ui_manager.render(); // そのほかのボタンのレンダリング
    }

    void startChapter() {
        // 確認画面を出して、よかったらそのまま開始、だめだったら最初から
        getGameMaster().replaceState(
            new YesNoDialog(
                "この構成でよろしいですか？\n" +
                skill_deck.get(0).skillShortDescription() + "\n" + 
                skill_deck.get(1).skillShortDescription() + "\n" + 
                skill_deck.get(2).skillShortDescription(),
                new ChapterLoading(chapter, skill_deck),
                new SkillSelect(chapter)
            )
        );
    }
}
