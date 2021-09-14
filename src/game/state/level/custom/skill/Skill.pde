/*
 * スキルを表すクラス。スキルが発動された瞬間に生成される。
 */
abstract class Skill implements Entity {
    float x, y, lifetime_ms; // 設定された座標と経過時間
    boolean is_removable = false; // スキルがすでに終わっているかどうか
    CustomBreakout break_out; // スキルは本体との通信が不可欠

    Skill(CustomBreakout break_out) {
        this.break_out = break_out;
    }

    Skill(CustomBreakout break_out, float x, float y) {
        this.break_out = break_out;
        this.x = x;
        this.y = y;
    }

    abstract boolean updateImpl(float time_delta_ms); // スキル本体の処理

    abstract void render(float offset_x, float offset_y); // スキル本体の描画

    final boolean update(float time_delta_ms) { //  Breakout側から呼び出されるべきアップデート
        is_removable = !updateImpl(time_delta_ms);
        lifetime_ms += time_delta_ms;
        return is_removable;
    }

    final boolean isRemovable() {
        return is_removable;
    }
}
