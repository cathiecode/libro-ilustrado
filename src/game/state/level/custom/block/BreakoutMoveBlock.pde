/*
 * 一定時間動いて所定の位置につくブロック。BreakoutBlockSpawnerによって生成されることが多いかも。
 */
class BreakoutMoveBlock extends BreakoutBlock {
    float lifetime_ms = 0; // 経過時間
    float dest_x, dest_y; // 行き着く場所
    float duration_ms;    // 所要時間

    BreakoutMoveBlock(float _x, float _y, float _width, float _height, float dest_x, float dest_y, float _duration_ms) {
        super(_x, _y, _width, _height, new TextureStyledRect("assets/move_paint_block.png"));
        duration_ms = _duration_ms;
        set_speed((dest_x - _x) / _duration_ms, (dest_y - _y) / _duration_ms); // 所要時間でちょうど所定の位置に動くように調整して速度を設定
    }

    void update(float time_delta_ms) {
        super.update(time_delta_ms);
        if (lifetime_ms > duration_ms) { // 所要時間経過後はもう動かさない
            set_speed(0, 0);
        }
        lifetime_ms += time_delta_ms;
    }
}
