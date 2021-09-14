/*
 * アニメーションを表すクラス。
 * lifetimeはAnimationがaddされてから経過した時間msを表し、自動更新される。
 * このメソッドは継承されなければならない。
 */
abstract class Animation implements Entity {
    boolean is_removable;

    /*
     * 継承先でアニメーションを描画すべきメソッド。time_delta_msは前回から経過している(と伝達された)時間ms。
     * 次フレームで描画されることを希望するならTrue、すでに終了したアニメーションの場合Falseを返すべきである。
     */
    abstract boolean update(float time_delta_ms);

    final boolean updateAndCheckIsRemovable(float time_delta_ms) {
        boolean update_result = update(time_delta_ms);
        is_removable = !update_result;
        return update_result;
    }

    // アニメーションをレンダリングすべきメソッド。update()で更新した情報をもとに好きな状態を描画しよう。
    abstract void render();

    // リセット要求が来たときに呼び出されるメソッド。
    void reset() {}

    // リセット要求が来たときに最初に呼び出されるメソッド。触るな。
    void _reset() {
        reset();
    }

    boolean isRemovable() {
        return is_removable;
    }
}
