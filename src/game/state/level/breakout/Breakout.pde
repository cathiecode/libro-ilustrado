/*
 * 多分割と一般的なBreakoutのルールセットを実装したもの。
 * いろいろなものに依存しないように書かれているのでこれさえあれば「ブロック崩し」と名の付くものは
 * 割となんでも作れる…はず…
 */
class Breakout extends EventEmitter<BreakoutEvent> {
    // 渡される数値類
    float     stage_width, stage_height;
    float     ball_size;

    // その他のフィールド
    BreakoutPaddle                paddle;
    BreakoutRect[]                walls;
    EntityManager<BreakoutBall>   balls =  new EntityManager();
    EntityManager<BreakoutBlock>  blocks = new EntityManager();

    Breakout(float _stage_width, float _stage_height, float _ball_size, BreakoutPaddle paddle) {
        stage_width = _stage_width;
        stage_height = _stage_height;
        ball_size = _ball_size;
        this.paddle = paddle;
        constructWalls();
    }

    void constructWalls() { // 壁を作る
        StyledRect wall_styled_rect = INVISIBLE_STYLED_RECT;
        walls = new BreakoutRect[3];
        // 上(10px大きくとっておく)
        walls[0] = new BreakoutRect(stage_width / 2, -5, stage_width + 10, 10, wall_styled_rect);
        // 左
        walls[1] = new BreakoutRect(-5 , stage_height / 2, 10, stage_height + 10, wall_styled_rect); 
        // 右
        walls[2] = new BreakoutRect(stage_width + 5,  stage_height / 2, 10, stage_height + 10, wall_styled_rect);
    }

    void castBall(BreakoutBall ball) { // 指定されたボールを中心から真下に投げる
        ball.accel(0, 0.3);
        balls.addLater(ball);
    }

    void update(float time_delta_ms) {
        // パドル系
        paddle.update(time_delta_ms);
        if (paddle.x <= paddle.width / 2) { // パドルが左に行き過ぎ
            paddle.x = paddle.width / 2;
        }
        if (paddle.x >= stage_width - paddle.width / 2) { // パドルが右に行き過ぎ
            paddle.x = stage_width - paddle.width / 2;
        }

        // ボール系
        ballInteraction(time_delta_ms);
        emit();
    }

    void ballInteraction(float time_delta_ms) {
        for (BreakoutBall ball: balls) {
            // ブロックとボール
            for (BreakoutBlock block: blocks) {
                if (ball.applyFutureBounce(block, time_delta_ms)) { // ぶつかったとき
                    ball.attack(block);
                    if (ball.isBallDamage()) {
                        regist(BreakoutEvent.BLOCK_BALL_DAMAGE);
                    }
                }
            }

            // パドルとボール
            if (paddle.applyBallHit(ball)) {
                regist(BreakoutEvent.PADDLE_TOUCHED);
            }

            // 壁とボール
            for (BreakoutRect wall: walls) {
                ball.applyFutureBounce(wall, time_delta_ms);
            }
            ball.update(time_delta_ms);
        }

        // ブロックをすべて更新
        for (BreakoutBlock block: blocks) {
            block.update(time_delta_ms);
            if (block.shouldBrokenByDamage()) {
                block_broke(block); // ブロックが壊れたらイベントを発生させる
            }
        }

        // ブロックの削除
        if (blocks.applyPendingModifications() != 0) {
            if (blocks.size() == 0) {
                regist(BreakoutEvent.PERFECT); // ブロックがなくなっていたらイベントを発生させる
            }
        }

        // ボールの削除
        for (BreakoutBall ball: balls) {
            if (ball.y >= stage_height + ball.height) {
                regist(BreakoutEvent.BALL_FELL); // ボールが落ちたらイベントを発生させる
                ball.fall(); // ボール側に「お前はもう死んでいる」と伝える
            }
        }
        balls.applyPendingModifications(); // ボールの削除を反映
    }

    void render(float _x, float _y) {
        for (BreakoutBlock block: blocks) { // ブロックの描画
            block.render(_x, _y);
        }
        for (BreakoutRect wall: walls) { // TODO: 削除
            wall.render(_x, _y);
        }
        paddle.render(_x, _y);
        for (BreakoutBall ball: balls) { // ボールの描画
            ball.render(_x, _y);
        }
    }

    // ブロックが壊されたときにイベントを発生させる
    void block_broke(BreakoutBlock block) {
        regist(BreakoutEvent.BROKE); 
    }
}
