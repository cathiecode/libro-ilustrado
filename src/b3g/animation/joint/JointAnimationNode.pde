/*
 * JointAnimationRootの子。こいつも子を持つことができる。
 */
class JointAnimationNode {
    float offset_x, offset_y, offset_z; // originを置く位置
    float origin_x, origin_y, origin_z; // 画像の回転中心
    float size_x, size_y;               // 画像の大きさ
    StyledRect styled_rect = INVISIBLE_STYLED_RECT; // 画像
    ArrayList<JointAnimationNode> children = new ArrayList(); // 子

    // 実際の(つまり、実装された)updateに影響されないように子を確実にupdateするためのメソッド
    void _update(float time_delta_ms) {
        update(time_delta_ms); // 実装されたupdateを呼び出す
        for (JointAnimationNode child: children) {
            child._update(time_delta_ms);
        }
    }

    // 設定された情報に従って描画
    void render() {
        pushMatrix(); // 変形があとに影響しないようにする
            translate(offset_x, offset_y); // 位置をずらしておく
            applySelfTransform();          // 実装されたアニメーションのコードを呼び出す

            // 描画(origin_x, origin_yが(0, 0)、つまり(offset_x, offset_y)に来るように座標を指定している)
            styled_rect.render(-origin_x, -origin_y, size_x, size_y);
            for (JointAnimationNode child: children) { // 子を描画(上のtranslateの影響を受ける)
                child.render();
            }
        popMatrix(); // 後続の描画に影響しないようにする
    }

    // 画像の回転中心を設定
    protected void setOrigin(float x, float y, float z) {
        origin_x = x;
        origin_y = y;
        origin_z = z;
    }

    // 親のoriginから見たoffsetを指定
    protected void setOffset(float x, float y, float z) {
        offset_x = x;
        offset_y = y;
        origin_z = z;
    }

    // 画像のサイズを指定
    protected void setSize(float w, float h) {
        size_x = w;
        size_y = h;
    }

    // 画像を指定
    protected void setNodeImage(StyledRect styled_rect) {
        this.styled_rect = styled_rect;
    }

    // 実装されるべきもの。大抵は毎フレーム呼び出される。
    void update(float time_delta_ms) {

    }

    // 実装で表現すべき変形動作はここで行う。
    void applySelfTransform() {

    }

    final void _reset() {
        reset(); // 実装にreset指示を送る
        for (JointAnimationNode child: children) { // リセット指示を子に伝達
            child._reset();
        }
    }

    // 実装でリセットする必要があればここで
    void reset() {}
}
