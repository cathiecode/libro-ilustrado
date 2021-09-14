/*
 * しおりっぽいボタン
 */

float BOOKMARK_OFFSET_X = 30;
class BookmarkButton extends UiClickableImage {
    String label;
    BookmarkButton(String _id, String label, float center_x, float center_y, String variation) {
        super(_id, "data/assets/ui/bookmark_" + variation + ".png", center_x - BOOKMARK_OFFSET_X, center_y); // variationで色を変えられる
        this.label = label;
    }

    void render(boolean is_hovered, boolean is_pushed) {
        super.render(is_hovered, is_pushed); // ボタンの描画
        GameGlobal.default_font_style.apply();
        textAlign(CENTER, CENTER);
        text(this.label, this.x + BOOKMARK_OFFSET_X, this.y); // ラベルを描画
    }
}
