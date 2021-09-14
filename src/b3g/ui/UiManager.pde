/*
 * UIの要素を管理し、描画するクラス。
 * 実質UiClickable専用。
 */
class UiManager {
    ArrayList<UiClickable> clickables = new ArrayList(); // クリック可能なものの配列
    GameInputHandler input_handler;

    UiManager(GameInputHandler input_handler) {
        this.input_handler = input_handler;
    }

    // 現状をチェックしてみて、クリックされているものがあればそのIDを返す
    String check_clicked() {
        for (UiClickable clickable: clickables) { // 全部見る
            boolean is_hovered = clickable.is_inner_point(mouseX, mouseY); // Aabbを利用してホバー確認
            boolean is_pushed = is_hovered && input_handler.mouseButtonOneshot(LEFT); // ホバーされていて、マウスが押されているなら、それは「押されている」はず
            if (is_pushed) {
                return clickable.id;
            }
        }
        return ""; // NOTE: nullを返すとswitchでNullPointerExceptionなので空文字列を返す
    }

    String check_hovered() {
        for (UiClickable clickable: clickables) { // 全部見る
            boolean is_hovered = clickable.is_inner_point(mouseX, mouseY); // Aabbを利用してホバー確認
            if (is_hovered) {
                return clickable.id;
            }
        }
        return ""; // NOTE: nullを返すとswitchでNullPointerExceptionなので空文字列を返す
    }

    // 管理している要素をレンダリング。いろいろズレるのでoffsetには対応しない。
    void render() {
        for (UiClickable clickable: clickables) {
            // 状態を確認してclickableのrenderを呼び出す
            boolean is_hovered = clickable.is_inner_point(mouseX, mouseY);
            boolean is_pushed = is_hovered && input_handler.mouseButton(LEFT);
            clickable.render(is_hovered, is_pushed);
        }
    }

    // UiClickableを追加
    void addClickable(UiClickable clickable) {
        clickables.add(clickable);
    }
}
