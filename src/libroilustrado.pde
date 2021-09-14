/*
  リブロ・イラストラド “動く”絵本と魔法のシール
*/

/*
    # 説明

    ## 必要なもの
    - Processing.Sound
    - 十分に高速なGPU
    
    ---

    ## おねがい
    - 長時間白い画面が続くことがあります。画像などをロードしているのでお待ち下さい。

    ---

    ## 遊び方

    ### ゲームの説明
    - スキルを使ってステージをクリアするゲームです。
    - クリア条件はすべてのブロック、敵を破壊することです。
    - 前のチャプターをクリアしていないと進めません。
    - スキルの組み合わせを考えてクリア、あわよくばS評価を取っていきましょう。

    ### 使用ボタンなど
    - 基本操作(移動など): マウス
    - スキル選択: 1, 2, 3

    ### 個々の操作
    - スキル発動: スキル選択→使いたい位置でクリック

    ---

    ## ソースコードを読む人向けの説明

    ### タブの説明
    - b3g: ゲームのための補助的な機能を集めたもの
    - b3g_animation: アニメーションを補助するクラス群
    - b3g_animation_joint: 物と物を関節でつなげたアニメーションを補助するクラス群
    - b3g_audio: 音を補助するクラス群
    - b3g_ui: UIまわりを補助するクラス群
    - b3g_utils: その他の様々な機能を補助するクラス群
    - game: ゲームのロジック
    - game_animations: ゲームで使うアニメーションを定義するファイル
    - game_player_data: セーブデータをつかさどるクラス群
    - game_state_level: ゲームのプレイ部分をつかさどるクラス群
        - game_state_level_breakout: ブロック崩しの基礎的な部分を実装するクラス群
        - game_state_level_custom: ブロック崩しの応用的な部分を実装するクラス群
        - game_state_level_custom_balls: ボール類を実装するクラス群
        - game_state_level_custom_block: ブロックを実装するクラス群
        - game_state_level_custom_skill: スキルの基礎的な部分を実装するクラス群
        - game_state_level_custom_skills: 様々なスキルを実装するクラス群
        - game_state: ゲームの状態(ページ?)を実装するクラス群
        - game_ui: ゲームのボタンなどを実装するクラス群
    - version: バージョン情報

*/

// ゲームの状態変遷をつかさどるインスタンス
GameMaster game_master;

// FIXME: こんなところにシェーダーをおいておく訳にはいかないが時間がない
PShader post_process_shader;

void setup() {
    size(1280, 960, P3D); // 3D演出とシェーダー用にP3Dレンダラを使用
    initGameGlobal(); // グローバル変数類を初期化
    post_process_shader = loadShader("shaders/postprocess.glsl"); // 画面効果をロード
    
    // ゲームのエントリーポイントを初期化
    game_master = new GameMaster(new DebugLayerState(GameGlobal.background), this, 60);

    // 重いアセットをロード
    //thread("preloadAssets");
    thread("preloadTitleAssets");

    // タイトル画面を実行
    game_master.pushState(new WaitTitleAssetLoading(new Title(true)));
}

void draw() {
    // 更新と描画
    game_master.handleDraw();

    // 画面効果のロードに成功していたら使用
    if (post_process_shader != null) filter(post_process_shader);
}

// アセットの事前ロードに成功したかどうか
boolean isAssetsPreloaded = false;

// 一部のめちゃくちゃ重いアセットだけプリロードしておく。推奨機のメモリ量なら大丈夫なはず…
void preloadAssets() {
    AssetLoader.audio("audio/bgm/n140.mp3");
    AssetLoader.audio("audio/bgm/n62.mp3");
    AssetLoader.audio("audio/bgm/n140.mp3");
    AssetLoader.audio("audio/bgm/m2.mp3");
    AssetLoader.audio("audio/bgm/n44.mp3");
    AssetLoader.audio("audio/bgm/n113.mp3");

    AssetLoader.image("assets/ball_water.png");
    AssetLoader.image("assets/ball_red.png");
    AssetLoader.image("assets/bgs/meadow.png");
    AssetLoader.image("assets/bgs/woods.png");
    AssetLoader.image("assets/bgs/castle.png");

    isAssetsPreloaded = true;
}


boolean isTitleAssetsPreloaded = false;

void preloadTitleAssets() {
    AssetLoader.audio("audio/bgm/c19.mp3");
    isTitleAssetsPreloaded = true;
    preloadAssets();
}

// キーボードを押したとき
void keyPressed() {
    game_master.handleKeyPressed();
}

// キーボードを離したとき
void keyReleased() {
    game_master.handleKeyReleased();
}

// マウスが動かされた瞬間
void mouseMoved() {
    game_master.handleMouseMoved();
}

// マウスボタンが押された時
void mousePressed() {
    game_master.handleMousePressed();
}

// マウスボタンが離された時
void mouseReleased() {
    game_master.handleMouseReleased();
}
