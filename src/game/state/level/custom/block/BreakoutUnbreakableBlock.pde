/*
 * スキルとかで壊れない（ただし、ある条件で壊れる）ブロックがほしいときに使えるやつ
 */
class BreakoutUnbreakableBlock extends BreakoutBlock {
    BreakoutUnbreakableBlock(float _x, float _y, float _width, float _height) {
        super(_x, _y, _width, _height, new TextureStyledRect("assets/normal_block.png"));
    }

    void damage() {
        // Do nothing
    }

    void destroy() {
        super.damage(); // 特殊な経路のみで破壊を許可する
    }
}
