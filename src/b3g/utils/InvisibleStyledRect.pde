// ただの何も見えないStyledRect
StyledRect INVISIBLE_STYLED_RECT = new InvisibleStyledRect();

class InvisibleStyledRect extends StyledRect {
    void render(float x, float y, float width, float height) {
        // DO NOTHING
    }
}
