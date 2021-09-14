/*
 * ただのrectを表示させたい場合に使うStyledRect(画像がない場合のプレースホルダー用)
 */
class PrimitiveStyledRect extends StyledRect {
    DrawStyle style;
    PrimitiveStyledRect(DrawStyle _style) {
        style = _style;
    }
    void render(float x, float y, float width, float height) {
        style.apply();
        rect(x, y, width, height);
    }
}
