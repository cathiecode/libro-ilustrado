/*
 * ぽよぽよテキストが出てきて規定時間で消えるアニメーションです。
 */

class PoyonText1 extends Animation {
    AnimationManager manager = new AnimationManager(); // 親のアニメーションマネージャを使うわけには行かないので自分で持っておく
    float lifetime_ms = 0;
    float animation_duration_ms; // アニメーションの長さ
    PoyonText1(String text, float x, float y, FontStyle _style, float _animation_duration_ms) {
        animation_duration_ms = _animation_duration_ms;
    
        float x_offset = 0;
        _style.apply();
        for (String indivisual_char: text.split("")) {
            manager.add(new IndivisualText(indivisual_char, x + x_offset, y, _style, animation_duration_ms * 0.5, animation_duration_ms));
            x_offset += textWidth(indivisual_char);
        }
    }

    boolean update(float time_delta_ms) {
        if (lifetime_ms >= animation_duration_ms) return false;
        manager.update(time_delta_ms);
        lifetime_ms += time_delta_ms;
        return true;
    }

    void render() {
        manager.render(0, 0);
    }

    class IndivisualText extends Animation {
        String text_string;
        FontStyle style;
        float animation_duration_ms;
        float total_duration_ms;
        float lifetime_ms = 0;
        float x, y;
        IndivisualText(String _text, float _x, float _y, FontStyle _style, float _animation_duration_ms, float _total_duration_ms) {
            text_string = _text;
            animation_duration_ms = _animation_duration_ms;
            total_duration_ms = _total_duration_ms;
            style = _style;
            x = _x;
            y = _y;
        }

        boolean update(float time_delta_ms) {
            if (lifetime_ms >= total_duration_ms) return false;

            lifetime_ms += time_delta_ms;
            return true;
        }

        void render() {
            style.apply();
            float ratio = max(0, (animation_duration_ms - lifetime_ms) / animation_duration_ms);
            textSize(style.size + style.size * sin(ratio * TWO_PI * 6) * ratio); // Magic numberは跳ねる回数
            textAlign(CENTER, CENTER);
            text(text_string, x, y);
        }
    }
}
