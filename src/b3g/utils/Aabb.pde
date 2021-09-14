/*
 * 簡略化された衝突判定を提供するクラス。継承してupdateAabb()を実装すると衝突判定機能が追加されます。
 * 詳細は“Axis aligned bounding box"で検索
 */
class Aabb {
    float left_x, top_y;
    float right_x, bottom_y;

    Aabb() {

    }

    // クラスをそのまま使うときのコンストラクタ。x1,y1は左上でなくてもよい。
    Aabb(float x1, float y1, float x2, float y2) {
        set_aabb(x1, y1, x2, y2);
    }

    // 他方のAabbと衝突しているかどうかを判定するメソッド。
    boolean isCollideWith(Aabb target) {
        updateAabb();
        target.updateAabb();
        return isCollideWithPos(target, left_x, top_y, right_x, bottom_y);
    }

    // 他方のAabbと衝突*するかどうか*を判定するメソッド。dx, dy分自身を動かしたときに衝突するかどうかを判定する。
    boolean willCollideWith(Aabb target, float dx, float dy) {
        updateAabb();
        target.updateAabb();
        return isCollideWithPos(target, left_x + dx, top_y + dy, right_x + dx, bottom_y + dy);
    }

    // dx, dy分自身を動かしたときに他方が自分から見てどちら側から衝突するかを計算するメソッド。結果は中心から衝突した面に向かうようなラジアン度数。
    float selfCollideDirection(Aabb target, float dx, float dy) throws Exception {
        updateAabb();
        target.updateAabb();
        boolean willCollideWithXMove = isCollideWithPos(target, left_x + dx, top_y, right_x + dx, bottom_y);
        boolean willCollideWithYMove = isCollideWithPos(target, left_x, top_y + dy, right_x, bottom_y + dy);

        if (willCollideWithXMove && !willCollideWithYMove) {
            if (dx >= 0) {
                return 0;
            } else {
                return 2 * HALF_PI;
            }

        }

        if (willCollideWithYMove && !willCollideWithXMove) {
            if (dy >= 0) {
                return 1 * HALF_PI;
            } else {
                return 3 * HALF_PI;
            }
        }

        throw new Exception("Couldn't detect direction");
    }
    
    // ある点(x,y)が内部に入っているかどうかを判定するメソッド。
    boolean is_inner_point(float x, float y) {
        updateAabb();
        return left_x <= x && x <= right_x && top_y <= y && y <= bottom_y;
    }

    // 位置を直接指定するメソッド。
    protected void set_aabb(float x1, float y1, float x2, float y2) {
        left_x = min(x1, x2);
        top_y = min(y1, y2);
        right_x = max(x1, x2);
        bottom_y = max(y1, y2);
    }

    // 継承先で実装されるべきメソッド。left_x~bottom_yを適切な値で更新すること。
    protected void updateAabb() {}

    // 内部メソッド。衝突判定の本体。
    private boolean isCollideWithPos(Aabb target, float _left_x, float _top_y, float _right_x, float _bottom_y) {
        if (_bottom_y <= target.top_y) return false; // 上すぎ
        if (_top_y >= target.bottom_y) return false; // 下すぎ
        if (_right_x <= target.left_x) return false; // 左すぎ
        if (_left_x >= target.right_x) return false; // 右すぎ
        return true;
    }
}
