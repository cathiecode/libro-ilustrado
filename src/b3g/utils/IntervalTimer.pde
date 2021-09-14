/*
 * 毎フレーム呼び出していると定期的にtrueを返すメソッドを提供するクラス
 * 
 * IntervalTimer timer = new IntervalTimer(1000);
 * ...
 *   if(timer.check_and_reset([前回呼び出しからの経過時刻])) {
 *     // 定期的にしたい処理
 *   }
 * ...
 */
class IntervalTimer {
    private float time_ms;
    private float interval_time_ms;

    IntervalTimer(float _intervalMS) {
        interval_time_ms = _intervalMS;
    }

    boolean check_and_reset(float time_delta_ms) {
        time_ms += time_delta_ms; // 内部時刻を進める
        if (time_ms < interval_time_ms) {  // 内部時刻が指定時刻に満ちていないとき
            return false;
        }
        time_ms -= interval_time_ms; // 指定時刻に達したので内部時刻からあまりを引いておく
        return true;
    }

    float remain_time_ms() {
        return interval_time_ms - time_ms;
    }
}