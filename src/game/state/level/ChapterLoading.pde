/*
 * チャプターを読み込んで実行するクラス。選択画面とかにこの処理を置きたくなかったので、
 * あえて独立したStateとして実装してある。
 */
class ChapterLoading extends GameState {
    SkillDeck skill_deck; // 渡されたデッキ
    ChapterMetaData metadata; // チャプターを読み込むのに必要な情報
    ChapterData chapter_entity; // チャプターデータの本体を入れられる変数を作っておく
    float lifetime_ms = 0;

    ChapterLoading(ChapterMetaData chapter_metadata, SkillDeck skill_deck) {
        this.metadata = chapter_metadata;
        this.skill_deck = skill_deck;
    }

    void onStateMount() {
        GameGlobal.background.nextPage(); // とりあえずここにきたら1枚めくっておく
        try {
            println("loading chapter data");
            chapter_entity = metadata.intoChapterDataEntity(); // チャプターの本ロードができないかやってみる
            println("done");
        } catch (Exception e) {
            // なにかミスったらここに飛ぶ
            game_master.replaceState(new YesNoDialog("Failed to load stage data.\nRetry?", this, this));
            return;
        }
    }

    void update(float time_delta_ms) {
        if(isAssetsPreloaded && lifetime_ms >= 3000) {
            // 正常に読み込めたらプレイ開始
            game_master.replaceState(new Level(chapter_entity, skill_deck));
        }
        lifetime_ms += time_delta_ms;
    }

    void render() {
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        fill(#000000);
        textSize(60);
        text("Loading...", 430, height / 2);
    }
}
