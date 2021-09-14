/*
 * ゲームのクリック可能なUI要素を表すクラス。
 */
class UiClickableImage extends UiClickable {
    PImage ui_image; // 画像
    float x, y;      // 中心座標

    UiClickableImage(String _id, String image_file, float center_x, float center_y) {
        super(_id);
        ui_image = AssetLoader.image(image_file);
        x = center_x;
        y = center_y;
    }

    // UiManagerから自分の状態を受け取って描画する。
    void render(boolean is_hovered, boolean is_pushed) {
        if (is_hovered && !is_pushed) {
            // マウスオーバーされているとき、少し“浮く”
            image(ui_image, x - ui_image.width / 2 - ui_image.width * 0.01, y - ui_image.height / 2 - ui_image.width * 0.01);
        } else {
            // 押されてるか、何もないときは普通に描画される。
            image(ui_image, x - ui_image.width / 2, y - ui_image.height / 2);
        }
    }

    // 自分の位置を当たり判定に反映する
    void updateAabb() {
        if (ui_image == null) return;
        left_x = x - ui_image.width / 2;
        top_y = y - ui_image.height / 2;
        right_x = x + ui_image.width / 2;
        bottom_y = y + ui_image.height / 2;
    }
}
