import java.util.Map;
import java.util.TreeMap;

/*
 * アニメーションの面倒を見てくれるクラス。
 * 追加されたアニメーションを自動で呼び出し、必要なくなったアニメーションを取り除く。
 */
class AnimationManager extends EntityManager<Animation> {
    /*
     * アニメーションが描画されるべきタイミングで呼び出されるべきメソッド。
     * 
     */
    void render(float offset_x, float offset_y) {
        pushMatrix(); // これまでの変形を保存
            translate(offset_x, offset_y); // 要求に応じてアニメーション全体をズラす
            for (Animation animation: this) { // すべてのアニメーションに描画要求をする
                animation.render();
            }
        popMatrix(); // これまでの変形を復元
    }

    /* 
     * アニメーションが更新されるべきタイミングで呼び出されるべきメソッド。
     * time_delta_msはアニメーションをどれだけ進めるかを指定。終了したアニメーションは取り除かれる。
     */
    void update(float time_delta_ms) {
        // アニメーションすべてを呼び出す。
        for (Animation animation: this) {
            animation.updateAndCheckIsRemovable(time_delta_ms);
        }

        applyPendingModifications();
    }
}
