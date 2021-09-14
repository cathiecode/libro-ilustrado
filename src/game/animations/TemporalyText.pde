// 削除予定
class TemporalyText extends Animation {
    float lifetime_ms = 0;
    float lifespan_ms;
    float x, y;
    String text;
    FontStyle font_style;

    TemporalyText(String text, float x, float y, float lifespan_ms, FontStyle font_style) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.lifespan_ms = lifespan_ms;
        this.font_style = font_style;
    }
    
    boolean update(float time_delta_ms) {
        if (lifetime_ms >= lifespan_ms) {
            return false;
        }
        lifetime_ms += time_delta_ms;
        return true;
    }

    void render() {
        font_style.apply();
        text(this.text, this.x, this.y);
    }
}
