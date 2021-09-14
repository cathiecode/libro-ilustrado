/*
 * シングルトンが使えないのでそれっぽい構文て使えるグローバルオブジェクトを作るやつ
 */
GameGlobalJar GameGlobal;

class GameGlobalJar {
    // デフォルトのフォントの定義(初期化はここではできない)
    FontStyle default_font_style;
    
    // クレヨンフォントの本体
    PFont crayon_font = loadFont("fonts/NagurigakiCrayon-32.vlw");

    // ステージの並び順
    ChapterCompilation chapterCompilation = new ChapterCompilation();

    // 所持アイテム
    PlayerData player_data = loadPlayerData();

    // 存在するスキルの一覧
    SkillRegistory skill_registory = new SkillRegistory();

    // 背景用Stateをあらゆるところから叩けるようにGlobalにおいておく
    Background background = new Background();

    GameGlobalJar() { // うえで記述しづらいものをここで
        default_font_style = (new FontStyle()) // ゲーム内で標準的に使われる書体の定義
            .setFont(crayon_font)
            .setSize(32)
            .setAlign(LEFT, CENTER)
            .setColor(#000000);

        // ステージの並び順
        // メモ: ストーリーのベースは「行きて帰りし物語」である。
        // 各ステージのコメントは https://bit.ly/2Ra04lo を参照。
        ChapterMetaData chapter1 = new ChapterMetaData("Chapter 1", "assets/bgs/meadow.png", "audio/bgm/n140.mp3");
        chapter1.add("levels/chapter1/wave1");
        chapter1.add("levels/chapter1/wave2");
        chapter1.add("levels/chapter1/wave3");

        ChapterMetaData chapter2 = new ChapterMetaData("Chapter 2", "assets/bgs/woods.png", "audio/bgm/n62.mp3");
        chapter2.add("levels/chapter2/wave1");
        chapter2.add("levels/chapter2/wave2");
        chapter2.add("levels/chapter2/wave3");

        ChapterMetaData chapter3 = new ChapterMetaData("Chapter 3", "assets/bgs/ship.png", "audio/bgm/n140.mp3");
        chapter3.add("levels/chapter3/wave1");
        chapter3.add("levels/chapter3/wave2");
        chapter3.add("levels/chapter3/wave3");

        ChapterMetaData chapter4 = new ChapterMetaData("Chapter 4", "assets/bgs/desert.png", "audio/bgm/m2.mp3");
        chapter4.add("levels/chapter4/wave1");
        chapter4.add("levels/chapter4/wave2");
        chapter4.add("levels/chapter4/wave3");
        
        ChapterMetaData chapter5 = new ChapterMetaData("Chapter 5", "assets/bgs/castle.png", "audio/bgm/n44.mp3");
        chapter5.add("levels/chapter5/wave1");
        chapter5.add("levels/chapter5/wave2");
        chapter5.add("levels/chapter5/wave3");

        chapterCompilation.add(chapter1);
        chapterCompilation.add(chapter2);
        chapterCompilation.add(chapter3);
        chapterCompilation.add(chapter4);
        chapterCompilation.add(chapter5);
    }
}

// NOTE: setup()以降でなければ動かないコードがあるのでグローバルで初期化できない。
// ので、setup()内で動かせるようにするためのWorkaround
void initGameGlobal() {
    GameGlobal = new GameGlobalJar();
}
