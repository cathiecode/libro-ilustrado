float BEAM_SKILL_WIDTH = 10;

/*
 * ビームのスキル。
 */
class Beam extends Skill {
    Beam(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
    }

    void render(float offset_x, float offset_y) {

    }

    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms == 0) { // 最初だけ動かす
            Aabb self_bounding_box = new Aabb(x - BEAM_SKILL_WIDTH / 2, 0, x + BEAM_SKILL_WIDTH, break_out.stage_height); // ブロックとの当たり判定
            for (BreakoutBlock block: break_out.blocks) { // あたっているすべてのブロックに対してスキルダメージを与える
                if (self_bounding_box.isCollideWith(block)) {
                    block.skillDamage();
                }
            }

            // スキルシールのアニメーション
            break_out.animation_manager.add(new StickerAnimation(x, break_out.stage_height / 2, BEAM_SKILL_WIDTH, break_out.stage_height, 150, 300, AssetLoader.image("assets/stickers/beam.png")));
        }
        break_out.addVibration(20); // 振動を依頼
        return false; // 一回実行されてしまえばもういらないのでそのまま破棄可能
    }
}

class BeamSkillFactory extends SkillFactory {
    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new Beam(break_out, x, y);
    }

    // プレビュー
    void renderSkillPreview(CustomBreakout break_out, float pointer_x, float pointer_y) {
        rect(pointer_x - BEAM_SKILL_WIDTH / 2, 0, BEAM_SKILL_WIDTH, break_out.stage_height);
    }

    String skillTitle() {
        return "アクアビーム！";
    }

    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/stickers/beam.png"));
    }

    String skillDescription() {
        return "直線状にあるブロックを破壊する。";
    }

    float cost() {
        return 5;
    }
}
