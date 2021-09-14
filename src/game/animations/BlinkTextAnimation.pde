class BlinkTextAnimation extends Animation {
    float x, y, lifetime_ms;
    FontStyle font_style;
    String text;

    BlinkTextAnimation(float x, float y, String text, FontStyle font_style) {
        this.x = x;
        this.y = y;
        this.font_style = font_style;
        this.text = text;
        this.lifetime_ms = 0;
    }

    boolean update(float time_delta_ms) {
        this.lifetime_ms += time_delta_ms;
        return true;
    }

    void render() {
        this.font_style.apply();
        fill(this.font_style.fill_color, sin(lifetime_ms / 250 * TWO_PI) * 255);
        text(this.text, this.x, this.y);
    }
}