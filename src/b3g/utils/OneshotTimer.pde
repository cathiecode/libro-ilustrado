/*
 * 一回のみ動作させたいタイマー動作を提供するクラス
 * 
 * OneshotTimer timer = new OneshotTimer(1000);
 * ...
 *   if (timer.check([前回呼び出しからの経過時間])) {
 *      // 一定時間後にしたい処理
 *   }
 */
class OneshotTimer {
    private float lifetime_ms = 0; // タイマーが開始してからの時間
    private float dest_time_ms;    // タイマーを作動させる

    private boolean fired = true; // すでにtrueが返されたかどうか

    OneshotTimer(float dest_time_ms) {
        this.dest_time_ms = dest_time_ms;
    }

    boolean check(float time_delta_ms) {
        if (fired) return false; // すでに実行されていたらもう動かさない
        if (lifetime_ms <= dest_time_ms) { // ときが満ちていない場合
            lifetime_ms += time_delta_ms;
            return false;
        }
        fired = true;
        return true;
    }

    void start() { // タイマーを開始させる
        lifetime_ms = 0;
        fired = false;
    }
}
