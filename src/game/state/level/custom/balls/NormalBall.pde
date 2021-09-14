/*
 * 一番大事なボールを表すクラス。
 */
class NormalBall extends BreakoutBall {
    float lifetime_ms = 0;

    AnimationManager animation_manager = new AnimationManager(); // 水しぶきのアニメーション保持用

    IntervalTimer particle_spawn_timer = new IntervalTimer(20); // 水しぶきを出す間隔を制御するタイマー

    CustomBreakout break_out; // リキャストに必要

    NormalBall(float _x, float _y, CustomBreakout break_out) {
        super(_x, _y, 48, new TextureStyledRect("assets/ball_water.png"));
        this.break_out = break_out;
    }

    void fall() {
        super.fall();
        // NOTE: NormalBallが表しているのは基本的に"メイン"のボールであり、このオブジェクト以外にそのことを知り得るクラスはないのでここで再キャストの記述をしている
        //break_out.castBall(new NormalBall(break_out.paddle.x, break_out.paddle.y - 100));
        break_out.reCastBall();
    }

    void update(float time_delta_ms) {
        if (particle_spawn_timer.check_and_reset(time_delta_ms)) { // パーティクルを定期的に放出
            float particle_rad = atan2(dy, dx) + PI + random(-0.05, 0.05) * PI; // 飛んでく向きにランダム性を付与して気持ちいいアニメーションを実現
            float particle_speed = random(0.125); // スピードもランダム
            float particle_x = x + random(width / 2) - width / 4; // ランダムの中心がボールの中心になるように設定
            float particle_y = y + random(height / 2) - height / 4;
            
            for (int i = 0; i < 2; i++) { // とりあえず1度に2こ放出。 // NOTE: これIntervalTimerを10にするだけでよくない…？
                animation_manager.add(new Particle(particle_x, particle_y, cos(particle_rad) * particle_speed, sin(particle_rad) * particle_speed, 4, 500, #4ba7c8)); // TODO もっとまともなid生成
            }
        }

        if (lifetime_ms <= 3000) {
            x -= dx * time_delta_ms;
            y -= dy * time_delta_ms;
        }

        if (lifetime_ms <= 2500)  {
            if (visibility_timer.check_and_reset(time_delta_ms)) {
                visibility = !visibility;
            }
        } else {
            visibility = true;
        }

        animation_manager.update(time_delta_ms);
        super.update(time_delta_ms);

        lifetime_ms += time_delta_ms;
    }

    boolean visibility = true;
    IntervalTimer visibility_timer = new IntervalTimer(75);

    void render(float offset_x, float offset_y) {
        animation_manager.render(offset_x, offset_y);

        if (visibility) {
            super.render(offset_x, offset_y);
        }
    }
}
