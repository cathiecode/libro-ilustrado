/*
 * 一番のザコ敵。バリアを生成する。
 */
class BreakoutBlockSpawner extends BreakoutBlock {
    Breakout break_out; // バリアを生成するために保持している
    IntervalTimer interval_timer = new IntervalTimer(2000); // バリアを出す間隔

    BreakoutBlock[] children_slot; // バリアの情報を保持しておく
    int children_num; // バリアの数を保持しておく
    float duration_ms = 1500; // バリアが移動する時間

    float children_dx, children_dy;
    BreakoutBlockSpawner(float _x, float _y, float _width, float _height, int _children_num, Breakout _break_out) {
        super(_x, _y, _width, _height, new TextureStyledRect("assets/character_akuma.png"));
        break_out = _break_out;
        children_num = _children_num;
        children_slot = new BreakoutBlock[children_num]; 
    }

    void update(float time_delta_ms) {
        if (this.interval_timer.check_and_reset(time_delta_ms)) { // 常にバリアを貼っているとクリア不可能なので数秒おきに実行
            float distance = sqrt(pow(this.width, 2) + pow(this.height, 2)); // バリアと本体の距離。本体の大きさをもとに決める。
            for (int i = 0; i < this.children_num; i++) {
                if (this.children_slot[i] != null) { // バリアがすでに、あるいは過去に貼ってあった場合
                    if (!this.children_slot[i].isRemovable()) { // バリアが壊されていない場合
                        continue; // 再生成はしない
                    }
                }
                // バリアが壊れていたら直そう
                float rad = (i / (this.children_num - 1.0)) * PI; // 本体からみたバリアの角度。
                float dest_x = x + cos(rad) * distance;      // バリアの移動先
                float dest_y = y + sin(rad) * distance;
                // 移動先に向かって動くバリアを登録しておく
                this.children_slot[i] = new BreakoutMoveBlock(this.x, this.y, this.width, this.height, dest_x, dest_y, this.duration_ms); 
                this.break_out.blocks.addLater(children_slot[i]); // ゲーム本体のクラスにバリアの登録を依頼する
                break; // 一度に１こしかバリアははらないのでループを抜ける
            }
        }
    }

    void skillDamage() {
        // Do nothing; entities should not be beaten with skills.
    }
}
