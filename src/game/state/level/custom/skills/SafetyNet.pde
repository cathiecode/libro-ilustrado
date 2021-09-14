float SAFETY_NET_SKILL_SIZE = 10;

/*
 * 横方向に貫くようにブロックを跳ね返す壁を設置するスキル。
 */
class SafetyNet extends Skill {
    BreakoutHardBlock pseudo_block;

    SafetyNet(CustomBreakout break_out, float x, float y) {
        super(break_out, x, y);
        pseudo_block = new BreakoutHardBlock(break_out.stage_width / 2, y, break_out.stage_width, SAFETY_NET_SKILL_SIZE, 10);
    }
    boolean updateImpl(float time_delta_ms) {
        if (lifetime_ms == 0) {
            break_out.blocks.addLater(pseudo_block); // 発動されたらすぐに設置
        } else if (lifetime_ms >= 3000) {
            pseudo_block.destroy(); // 時間が経過したら削除
            return false;
        }
        return true;
    }

    void render(float offset_x, float offset_y) {

    }
}

class SafetyNetSkillFactory extends SkillFactory {
    StyledRect icon() {
        return new TextureStyledRect(AssetLoader.image("assets/stickers/trumpoline.png"));
    }
    String skillTitle()       {return "セーフティ・ネット";}
    String skillDescription() {return "一定時間ボールを反射するネットを設置する";}
    void renderSkillPreview(CustomBreakout break_out, float x, float y) {
        rect(0, y - SAFETY_NET_SKILL_SIZE / 2, break_out.stage_width, SAFETY_NET_SKILL_SIZE);
    }

    Skill createSkill(CustomBreakout break_out, float x, float y) {
        return new SafetyNet(break_out, x, y);
    }

    float cost() {
        return 2;
    }
}
