/*
 * Breakoutのブロックを表すクラス。
 */
class BreakoutBlock extends BreakoutMovableObject implements Entity {
    private boolean broken = false;
    BreakoutBlock(float _x, float _y, float _width, float _height, StyledRect styled_rect) {
        super(_x, _y, _width, _height, styled_rect);
    }

    boolean isRemovable() { // 安全に削除可能か？
        return shouldBrokenByDamage();
    }

    // ブロックにボールが当たった時に呼び出される
    void damage() {
        broken = true;
    }

    // スキルによる破壊が発生したときに呼び出される
    void skillDamage() {
        damage();
    }

    // ダメージによって壊れるべきかどうか。
    boolean shouldBrokenByDamage() {
        return broken;
    }
}
