/*
 * 水しぶきの表現など、小さくて丸いものを表現するためのAnimation
 */
class Particle extends Animation {
    float lifetime_ms = 0;
    float lifespan_ms; // アニメーションの長さ
    float dx_per_ms, dy_per_ms; // アニメーションの速度
    float accel_x_per_ms = 0, accel_y_per_ms = 0; // 加速度
    float x, y; // アニメーションの現在位置
    float size; // 円の大きさ

    color effect_color;

    Particle(float x, float y, float dx_per_ms, float dy_per_ms, float size, float lifespan_ms, color effect_color) {
        this.dx_per_ms = dx_per_ms;
        this.dy_per_ms = dy_per_ms;
        this.x = x;
        this.y = y;
        this.size = size;
        this.lifespan_ms = lifespan_ms;
        this.effect_color = effect_color;
    }

    boolean update(float time_delta_ms) {
        if (lifetime_ms >= lifespan_ms) return false;
        this.x += dx_per_ms * time_delta_ms; // 速度を積分
        this.y += dy_per_ms * time_delta_ms;
        this.dx_per_ms += accel_x_per_ms * time_delta_ms; // 加速度を積分
        this.dy_per_ms += accel_y_per_ms * time_delta_ms;
        lifetime_ms += time_delta_ms;
        return true;
    }

    void setGravity(float x, float y) { // 加速度の設定
        accel_x_per_ms = x;
        accel_y_per_ms = y;
    }

    void render() {
        fill(effect_color, 255 - lifetime_ms / lifespan_ms * 255); // 時間がたつにつれて透明に
        noStroke();
        circle(x, y, size);
    }
}
