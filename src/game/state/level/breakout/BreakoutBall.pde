/*
 * Breakoutのボールを表すクラス。これを継承して自分だけのボールを作ろう。
 */
class BreakoutBall extends BreakoutMovableObject implements Entity {
    boolean is_removable = false; // 安全に削除できるか？

    BreakoutBall(float _x, float _y, float _radius, StyledRect styled_rect) {
        super(_x, _y, _radius * 0.5, _radius * 0.5, styled_rect);
    }

    boolean isRemovable() { // 安全に削除できるか？
        return is_removable;
    }

    void fall() { // 落ちたときに呼び出される
        is_removable = true;
    }

    void attack(BreakoutBlock block) {
        block.damage();
        // イベント検知用
    }

    boolean isBallDamage() {
        return true;
    }

    boolean applyFutureBounce(Aabb target, float time_delta_ms) { // ちょっと先の未来でぶつかるかどうかを調べて反射させる
        float tdx = time_delta_ms * dx; // ちょっと先の未来の座標
        float tdy = time_delta_ms * dy;
        if (!willCollideWith(target, tdx, tdy)) { // ぶつからないなら何もせずにfalse
            return false;
        }

        float collide_direction; // ぶつかった向き(ラジアン)
        try {
            collide_direction = selfCollideDirection(target, tdx, tdy);
        } catch (Exception e) { // ぶつかった向きが判定できなかった場合
            println("フォールバック発動"); // デバッグ用
            collide_direction = atan2(tdy, tdx); // とりあえず真逆に跳ね返るようにしておく
        }

        // 以下のコードは https://qiita.com/edo_m18/items/b145f2f5d2d05f0f29c9 をもとにしている

        float a = (cos(collide_direction - PI) * dx) + (sin(collide_direction - PI) * dy);

        float new_dx = dx + 2 * -a * cos(collide_direction - PI);
        float new_dy = dy + 2 * -a * sin(collide_direction - PI);

        set_speed(new_dx, new_dy); // 反射させた向きに設定
        return true;
    }
}
