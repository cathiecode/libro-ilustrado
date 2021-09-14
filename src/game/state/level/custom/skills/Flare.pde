float FLARE_EFFECT_RADIUS = 100;
float FLARE_EFFECT_DELAY  = 3000;

/*
 * 水風船のスキル。名前がFlareなのは歴史的経緯だから気にしないでください。
 */
class Flare extends Skill {
    float effect_radius = FLARE_EFFECT_RADIUS; // 影響半径

    Flare(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
    }

    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms == 0) { // 一番最初だけ
            // スキルシールのアニメーションを追加
            break_out.animation_manager.add(new StickerAnimation(x, y, effect_radius * 2, FLARE_EFFECT_DELAY * 0.05, FLARE_EFFECT_DELAY * 0.95, AssetLoader.image("assets/stickers/bomb.png"))); // TODO: renderに移す
        } else if (lifetime_ms >= FLARE_EFFECT_DELAY) { // ちょっと待ってから実行
            for (BreakoutBlock block: break_out.blocks) { // 範囲内のブロック全てにスキルダメージを付与
                if (sqrt(pow(block.x - x, 2) + pow(block.y - y, 2)) <= effect_radius) {
                    block.skillDamage();
                }
            }

            // 以下、水しぶきのアニメーション
            float speed = effect_radius / 1000;
            float particle_size = effect_radius / 10;
            for (int i = 0; i < 10; i++) {
                float angle0 = (random(0, PI) + PI); // 上方向180度のどこかに投げる
                float offset_x = random(effect_radius * 2) + x - effect_radius; // 発射点はシールの領域のどこか
                float offset_y = random(effect_radius * 2) + y - effect_radius;
                Particle particle = new Particle(offset_x, offset_y, speed * cos(angle0), speed * sin(angle0), particle_size, 500, #4ba7c8);
                particle.setGravity(0, 0.001); // 小さめに重力を設定しておく
        
                break_out.animation_manager.addLater(particle);
            }
            break_out.addVibration(50); // 大きめに画面揺れを依頼する
            return false;
        }
        return true;
    }

    void render(float offset_x, float offset_y) {
        
    }
}

class FlareSkillFactory extends SkillFactory {
    float effect_radius = FLARE_EFFECT_RADIUS;

    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new Flare(break_out, x, y);
    }

    void renderSkillPreview(CustomBreakout break_out, float pointing_x, float pointing_y) {
        // 見た目より壊れなかったら嫌なのでちょっと小さめにプレビュー
        circle(pointing_x, pointing_y, effect_radius * 2 * 0.9);
    }

    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/stickers/bomb.png"));
    }

    String skillTitle() {
        return "巨大水フーセン";
    }

    String skillDescription() {
        return "円形範囲内のブロックを破壊する。";
    }

    float cost() {
        return 6;
    }
}
