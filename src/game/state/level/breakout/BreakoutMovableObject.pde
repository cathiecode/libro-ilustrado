/*
 * Breakoutで移動するオブジェクトを表すクラス。
 */
class BreakoutMovableObject extends BreakoutRect {
    float dx = 0, dy = 0; // 速度
    BreakoutMovableObject(float _x, float _y, float _width, float _height, StyledRect styled_rect) {
        super(_x, _y, _width, _height, styled_rect);
    }
    BreakoutMovableObject accel(float _x, float _y) { // 加速
        dx += _x;
        dy += _y;
        return this;
    }
    BreakoutMovableObject set_speed(float _x, float _y) { // 速度設定
        dx = _x;
        dy = _y;
        return this;
    }
    void update(float timeDeltaMS) {
        setPos(x + dx * timeDeltaMS, y + dy * timeDeltaMS); // 速度から移動
    }
}
