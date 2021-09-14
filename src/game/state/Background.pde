/*
 * 背景のState
 */
class Background extends GameState {
    GameState game_state;
    BookAnimation book = new BookAnimation(760, height / 2, 20);  // 背景ようの絵本
    PImage background_image = AssetLoader.image("assets/bg.png"); // 机

    float children_invisible_remaining_time = 0; // フォアグラウンドを非表示にする残り時間
    
    AnimationManager animation_manager = new AnimationManager(); // アニメーションを入れておくコンテナ

    Background() {
        animation_manager.add(book);
    }

    void onBecameTop() {
        getGameMaster().popState(); // 自分が一番上になったら自分も消える
    }

    void update(float time_delta_ms) {
        children_invisible_remaining_time -= time_delta_ms; // 非表示の残り時間を減らす

        animation_manager.update(time_delta_ms); // アニメのアップデート
    }

    void render() {

        pushMatrix();
            translate(0, 0, -65);
            image(background_image, -100, -100, width * 1.2, height * 1.2); // 机の描画
        popMatrix();

        beginCamera(); // 背景用カメラを始める

        float fov = radians(40);
        float cameraZ = (height / 2.0) / tan(fov/2.0);
        perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0); // 背景用カメラの設定
        camera(width / 2, height / 2, cameraZ, width / 2, height / 2, 0, 0, 1.0, 0); // 背景用カメラの配置

        translate(0, 0, -35); // Z軸方向の位置をちょっといじる
        animation_manager.render(0, 0);

        endCamera(); // 背景用カメラを終わる

        // もとのカメラにもどしておく
        camera();
        perspective();

        // 非表示の残り時間が残ってたら非表示
        if (children_invisible_remaining_time > 0) {
            getGameMaster().finishRendering();
        }
    }

    // あるページを開く
    void openPage(int number) {
        movePage();
        book.openPage(number);
    }

    // 次のページを開く
    void nextPage() {
        movePage();
        book.nextPage();
    }

    // 表紙側に閉じる
    void closeToHead() {
        movePage();
        book.closeToHead();
    }

    // 裏表紙側に閉じる
    void closeToBehind() {
        movePage();
        book.closeToBehind();
    }

    void movePage() {
        children_invisible_remaining_time = 1200;
    }
}
