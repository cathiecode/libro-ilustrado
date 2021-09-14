class UiClickableText extends UiClickable {
    String label;
    FontStyle font_style;

    float x, y;
    float text_width, text_height;

    UiClickableText(String id, String label, float x, float y, FontStyle font_style) {
        super(id);
        this.label = label;
        this.font_style = font_style;

        this.x = x;
        this.y = y;
        this.font_style.apply();
        text_width = textWidth(this.label);
        text_height = this.font_style.size;
    }

    void render(boolean is_hovered, boolean is_pushed) {
        this.font_style.apply();
        textAlign(CENTER, CENTER);
        if (is_hovered && !is_pushed) {
            // マウスオーバーされているとき、少し“浮く”
            text(this.label, this.x - this.text_width * 0.01, this.y - this.text_width * 0.01);
        } else {
            // 押されてるか、何もないときは普通に描画される。
            text(this.label, this.x, this.y);
        }
    }

    void updateAabb() {
        left_x   = this.x - this.text_width / 2;
        right_x  = this.x + this.text_width / 2;
        top_y    = this.y - this.text_height / 2;
        bottom_y = this.y + this.text_height / 2;
    }
}
