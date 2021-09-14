class FontStyle extends DrawStyle implements Cloneable {
    PFont font;
    Float size, leading;
    Integer align_x, align_y;

    // なりゆきに任せる
    FontStyle() {
        super();
    }

    FontStyle(PFont _font, float _size) {
        font = _font;
        size = _size;
    }

    FontStyle setFont(PFont _font) {
        font = _font;
        return this;
    }

    FontStyle setSize(float _size) {
        size = _size;
        return this;
    }

    FontStyle setLeading(float _leading) {
        leading = _leading;
        return this;
    }

    FontStyle setAlign(int _align_x, int _align_y) {
        align_x = _align_x;
        align_y = _align_y;
        return this;
    }

    FontStyle setColor(color _color) {
        super.setFill(_color);
        return this;
    }

    void apply() {
        super.apply();
        if (font != null) {
            textFont(font);
        }
        if (size != null) {
            textSize(size);
        }
        if (leading != null)  {
            textLeading(leading);
        }
        if (align_x != null) { // NOTE: alignYだけの指定はtextAlignではできんのだ
            if (align_y != null) {
                textAlign(align_x, align_y);
            } else {
                textAlign(align_x);
            }
        }
    }

    FontStyle clone() throws CloneNotSupportedException {
        FontStyle clone = (FontStyle) super.clone();
        return clone;
    }
}
