float PSEUDO_BLOCK_SKILL_SIZE = 50;

/*
 * 疑似(でもないけど…)ブロック設置スキル
 */
class PseudoBlockSkill extends Skill {
    BreakoutBlock pseudo_block = new BreakoutNormalBlock(x, y, PSEUDO_BLOCK_SKILL_SIZE, PSEUDO_BLOCK_SKILL_SIZE); // 設置した疑似ブロック
    PseudoBlockSkill(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
    }
    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms == 0) { // スキル発動されたらすぐに設置
            break_out.blocks.addLater(pseudo_block);
        } else if (lifetime_ms >= 5000) { // スキル時間が終わったら壊しておく
            pseudo_block.damage();
            return false;
        }
        return true;
    }

    void render(float offset_x, float offset_y) {
        
    }
}

class PseudoBlockSkillFactory extends SkillFactory {
    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new PseudoBlockSkill(break_out, x, y);
    }

    void renderSkillPreview(CustomBreakout break_out, float pointing_x, float pointing_y) {
        rect(pointing_x - PSEUDO_BLOCK_SKILL_SIZE / 2, pointing_y - PSEUDO_BLOCK_SKILL_SIZE / 2, PSEUDO_BLOCK_SKILL_SIZE, PSEUDO_BLOCK_SKILL_SIZE);
    }

    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/normal_block.png"));
    }

    String skillTitle() {
        return "まぼろしブロック";
    }

    String skillDescription() {
        return "一定時間後に消えるブロックを設置する";
    }

    float cost() {
        return 1;
    }
}
