/*
 * 一定時間で消えるボール
 */
class GhostBall extends BreakoutBall {
    float lifetime_ms;
    GhostBall(float _x, float _y) {
        super(_x, _y, 24, new TextureStyledRect("assets/ball_red.png")); // TODO: 画像をすげ替えることができるようにする
        lifetime_ms = 0;
    }
    boolean isRemovable() {
        if (lifetime_ms >= 5000) return true; // 一定時間経過後はもう消せる
        return is_removable;
    }
    void update(float time_delta_ms) {
        lifetime_ms += time_delta_ms;
        super.update(time_delta_ms);
    }

    void attack(BreakoutBlock block) {
        block.skillDamage();
        is_removable = true;
    }

    boolean isBallDamage() {
        return false;
    }
}
