float FIXED_GUN_DURATION_MS = 8000; // 存在する長さ

/*
 * 固定砲台。
 */
class FixedGun extends Skill {
    IntervalTimer ball_timer = new IntervalTimer(1000); // 発射間隔
    float direction = random(0.0, 1.0) * PI + PI;

    FixedGun(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
    }

    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms >= FIXED_GUN_DURATION_MS) { // 一定時間で消す
            return false;
        }
        if (lifetime_ms == 0) { // 最初だけ実行
            break_out.animation_manager.add(new StickerAnimation(x, y, break_out.stage_width / 10, FIXED_GUN_DURATION_MS * 0.05, FIXED_GUN_DURATION_MS * 0.95, AssetLoader.image("assets/stickers/cannon.png"))); // TODO: renderに移す
        }
        // 最初の待機時間が終わったら発射開始
        if (lifetime_ms >= FIXED_GUN_DURATION_MS * 0.05) {
            if (ball_timer.check_and_reset(time_delta_ms)) { // 間隔を待つ
                float speed = break_out.stage_height / 1000; // 速度は適当
                BreakoutBall new_ball = new GhostBall(x, y); // 一定期間で消えるボール
                new_ball.accel(cos(direction) * speed, sin(direction) * speed);
                break_out.balls.addLater(new_ball); // 追加依頼
            }
        }
        return true;
    }

    void render(float offset_x, float offset_y) {
        
    }
}

class FixedGunFactory extends SkillFactory {
    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new FixedGun(break_out, x, y);
    }

    void renderSkillPreview(CustomBreakout break_out, float pointing_x, float pointing_y) {
        // FIXME: いろいろツッコミどころだらけだけど時間がない…FixedGunの位置ぴったりに描画できてるはず…
        rect(pointing_x - break_out.stage_width / 10 / 2, pointing_y - break_out.stage_width / 10 / 2, break_out.stage_width / 10, break_out.stage_width / 10);
    }

    String skillTitle() {
        return "固定砲台";
    }

    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/stickers/cannon.png"));
    }

    String skillDescription() {
        return "一定時間、大量のボールをばらまく";
    }

    float cost() {
        return 10;
    }
}
