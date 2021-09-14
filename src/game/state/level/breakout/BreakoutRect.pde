/*
 * Breakoutで使う矩形オブジェクトを表すクラス。
 */
class BreakoutRect extends Aabb {
    float x = 0, y = 0, width = 0, height = 0;
    StyledRect styled_rect;
    
    BreakoutRect(float _x, float _y, float _width, float _height, StyledRect _styled_rect) {
        x = _x;
        y = _y;
        width = _width;
        height = _height;
        styled_rect = _styled_rect;
    }

    void setPos(float _x, float _y) { // 位置を設定
        x = _x;
        y = _y;
    }

    void updateAabb() {
        set_aabb(x - width / 2, y - height / 2, x + width / 2, y + height / 2);
    }

    void render(float offset_x, float offset_y) { // レンダリング
        styled_rect.render(x - width / 2 + offset_x, y - height / 2 + offset_y, width, height);
    }
}
