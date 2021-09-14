float VACUUM_EFFECT_RADIUS      = 150;
float VACUUM_EFFECT_DURATION_MS = 3000;
float VACUUM_MOVE_PER_MS = 0.02;

/*
 * 掃除機スキル。周りにあるブロックを中心に集める。
 */
class Vacuum extends Skill {
    Vacuum(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
    }
    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms >= VACUUM_EFFECT_DURATION_MS) return false; // スキル時間が終わったら消す
        if (lifetime_ms == 0) { // 発動したらすぐにステッカーアニメ
            break_out.animation_manager.add(new StickerAnimation(x, y, VACUUM_EFFECT_RADIUS, VACUUM_EFFECT_DURATION_MS * 0.05, VACUUM_EFFECT_DURATION_MS * 0.95, AssetLoader.image("assets/stickers/vacuum.png"))); // TODO: 新しい画像に置き換える
        }
        for (BreakoutBlock block: break_out.blocks) { // 周りに有るブロックをすこしずつ中心に集める
            if (sqrt(pow(block.x - x, 2) + pow(block.y - y, 2)) <= VACUUM_EFFECT_RADIUS) { // FIXME: 外側に有るほど強く引き寄せないと見た目が不自然
                float direction = atan2(this.y - block.y, this.x - block.x);
                block.x += VACUUM_MOVE_PER_MS * time_delta_ms * cos(direction);
                block.y += VACUUM_MOVE_PER_MS * time_delta_ms * sin(direction);
            }
        }
        return true;
    }

    void render(float offset_x, float offset_y) {

    }
}

class VacuumSkillFactory extends SkillFactory {
    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/stickers/vacuum.png"));
    }
    String skillTitle()       {return "吸引！";}
    String skillDescription() {return "範囲内のブロックを中心に引き寄せる";}
    void renderSkillPreview(CustomBreakout break_out, float pointing_x, float pointing_y) {
        circle(pointing_x, pointing_y, VACUUM_EFFECT_RADIUS * 2);
    }

    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new Vacuum(break_out, x, y);
    }

    float cost() {
        return 4;
    }
}
