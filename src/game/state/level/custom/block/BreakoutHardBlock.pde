/*
 * もっとも一般的なブロック。動かない。
 */
class BreakoutHardBlock extends BreakoutBlock {
    int hp;

    BreakoutHardBlock(float _x, float _y, float _width, float _height, int hp) {
        super(_x, _y, _width, _height, new TextureStyledRect("assets/normal_block.png"));
        this.hp = hp;
    }
    
    void skillDamage() {
        addDamage(1);
    }

    void damage() {
        addDamage(1); // ボールによるダメージは多めに
    }

    void addDamage(int damage) {
        hp -= damage;
        if (hp <= 0) {
            super.damage();
        }
    }

    void destroy() {
        super.damage();
    }
}
