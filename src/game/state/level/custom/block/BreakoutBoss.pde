/*
 * 最終面のボス。
 */
class BreakoutBoss extends BreakoutBlock {
    float max_hp = 50; // 初期HP
    float hp = max_hp;
    float damage_effect_ratio = 0.0;
    AnimationManager animation_manager = new AnimationManager(); // ダメージ表示のためのアニメーションを保持

    BreakoutBoss(float _x, float _y, float _width, float _height, Breakout _break_out) {
        super(_x, _y, _width * 1.5, _height * 3.0, new TextureStyledRect("assets/boss.png"));
    }

    void update(float time_delta_ms) {
        damage_effect_ratio = damage_effect_ratio * pow(0.5, time_delta_ms / 100);
        animation_manager.update(time_delta_ms);
    }

    void render(float offset_x, float offset_y) {
        super.render(offset_x, offset_y);
        noStroke();
        fill(#aaaaaa);
        rect(offset_x + this.x - this.width / 2, offset_y + this.y - this.height / 2, this.width, this.width * 0.05); // HPバー(背景)
        fill(205 + damage_effect_ratio * 50, 0, 0);
        rect(offset_x + this.x - this.width / 2, offset_y + this.y - this.height / 2, this.width * (hp / max_hp), this.width * 0.05); // HPバー(本体)
        fill(#ff0000);

        animation_manager.render(offset_x + this.x, offset_y + this.y);

        //text(display_hp + "+" + gauge_num, x - width / 2 + offset_x, y - height / 2 + offset_y);
    }

    void skillDamage() {
        addDamage(1);
    }

    void damage() {
        addDamage(2); // ボールによるダメージは多めに
    }

    void addDamage(int damage) {
        hp -= damage;
        if (hp <= 0) {
            super.damage();
        }
        // 以下、アニメーション
        float x = random(-this.width,  this.width)  / 2;
        float y = random(-this.height, this.height) / 2;
        animation_manager.add(new DamageAnimation(x, y, damage));
        damage_effect_ratio = 1.0;
    }
}
