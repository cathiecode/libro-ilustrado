/*
 * 親子関係で接続された画像をアニメーションさせるためのクラス。
 */

class JointAnimationRoot extends Animation {
    float offset_x, offset_y; // 直下の子を表示する位置

    ArrayList<JointAnimationNode> children = new ArrayList(); // 子

    boolean update(float time_delta_ms) {
        for (JointAnimationNode child: children) { // 子をすべてアップデートする
            child._update(time_delta_ms);
        }
        return true; // Animationは基本的に永遠に続く
    }

    void render() {
        pushMatrix(); // これからする変形が他に影響しないようにする
            translate(offset_x, offset_y); // 子の位置を設定
            for (JointAnimationNode child: children) { // 子にすべて描画させる
                child.render();
            }
        popMatrix();
    }

    void setOffset(float x, float y) {
        offset_x = x;
        offset_y = y;
    }

    void _reset() {
        reset();
        for (JointAnimationNode child: children) {
            child._reset();
        }
    }
}
