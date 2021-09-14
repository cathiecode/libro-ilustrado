# Skillの作り方
```
class スキル名 extends Skill {
    boolean updateImpl(float time_delta_ms) {

    }

    void render(float offset_x, float offset_y) {

    }
}

class スキル名SkillFactory extends SkillFactory {
    String skillTitle()       {return "";}
    String skillDescription() {return "";}
    void renderSkillPreview(CustomBreakout break_out, float x, float y) {
        // TODO
    }

    Skill createSkill(CustomBreakout break_out, float x, float y) {
        // TODO
    }
}
```