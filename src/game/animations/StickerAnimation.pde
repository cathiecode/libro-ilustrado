/*
 * スキルシールのAnimation
 */
class StickerAnimation extends Animation {
    PImage anim_image;
    float lifetime_ms;
    float x, y;
    float i_width, i_height;
    float animation_duration_ms, stop_duration_ms;
    AnimationManager animation_manager;

    // アニメーションの横幅を自動設定しない場合
    StickerAnimation(float x, float y, float size, float animation_duration_ms, float stop_duration_ms, PImage anim_image) {
        this.x = x;
        this.y = y;
        this.i_width = size;
        this.i_height = size * (float(anim_image.height) / anim_image.width); // アニメーションの横幅を画像から自動で設定する
         
        this.animation_duration_ms = animation_duration_ms;
        this.stop_duration_ms = stop_duration_ms;
        this.animation_manager = animation_manager;
        this.anim_image = anim_image;
    }

    // アニメーションのサイズを手動で設定する場合
    StickerAnimation(float x, float y, float i_width, float i_height, float animation_duration_ms, float stop_duration_ms, PImage anim_image) {
        this.x = x;
        this.y = y;
        this.i_width = i_width;
        this.i_height = i_height;
        this.animation_duration_ms = animation_duration_ms;
        this.stop_duration_ms = stop_duration_ms;
        this.animation_manager = animation_manager;
        this.anim_image = anim_image;
    }

    boolean update(float time_delta_ms) {
        if (lifetime_ms > animation_duration_ms + stop_duration_ms + animation_duration_ms) { // アニメーションが終了した場合消す
            return false;
        }
        lifetime_ms += time_delta_ms;
        return true;
    }

    void render() {
        float ratio; // 0.0 -> 1.0 にかけて大きくなり、透明になる
        if (lifetime_ms <= animation_duration_ms) { // 最初の「はりつける」アニメーション
            ratio = 1.0 - lifetime_ms / animation_duration_ms;
        } else if (stop_duration_ms + animation_duration_ms <= lifetime_ms) { // 最後の「はがす」アニメーション
            ratio = (lifetime_ms - (stop_duration_ms + animation_duration_ms)) / animation_duration_ms;
        } else { // 止まっているときのアニメーション
            ratio = 0.0;
        }
        float anim_size = (1.0 - ratio) + (1.1 * ratio);
        float anim_width = anim_size * i_width;
        float anim_height = anim_size * i_height;

        tint(255, 255.0 * (1.0 - ratio)); // 剥がれているときは透明にしてゆく
        image(anim_image, x - anim_width / 2, y - anim_height / 2, anim_width, anim_height); // 中心座標を計算して表示
        tint(255, 255); // 一応tintしてないimageに影響がないように
    }
}
