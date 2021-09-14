/*
 * ボスなどに攻撃を当てたときにでるダメージ量が数値で出るやつ
 */
class DamageAnimation extends Animation {
    float lifetime_ms = 0;
    float x, y; // どこから出たか
    float offset_y = 0; // アニメーションがどれくらい上昇したか
    float animation_duration_ms = 1000; // アニメーションの長さ
    int damage; // 出すダメージ

    DamageAnimation(float x, float y, int damage) {
        this.x = x;
        this.y = y;
        this.damage = damage;
    }

    boolean update(float time_delta_ms) {
        if (lifetime_ms >= animation_duration_ms) { // ある程度時間経ったら消す
            return false;
        }
        this.offset_y -= time_delta_ms * 0.1; // ちょっとずつ上に動かす
        lifetime_ms += time_delta_ms;
        return true;
    }

    void render() {
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        fill(#ff0000, (1.0 - lifetime_ms / animation_duration_ms) * 255); // 時間がたつにつれて透明になっていく
        text(this.damage, x, y + offset_y);
    }
}
