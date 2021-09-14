StyledRect DEFAULT_SKILL_ICON = new PrimitiveStyledRect(new DrawStyle(#ffffff, #3333ff));

/*
 * Skillが生成される前にその情報を保持しておくクラス。「スキル」と「スキルカード」の違いみたいなもの。
 */
abstract class SkillFactory {
    StyledRect icon() { // アイコン
        return DEFAULT_SKILL_ICON;
    }

    void renderSkillPreview(CustomBreakout break_out, float pointing_x, float pointing_y) {} // スキル選択モード時のマウスオーバーでのプレビュー

    String skillDescription() {return "なにが起きるのでしょうか…？";} // スキルの説明書き
    String skillTitle()       {return "Unknown";} // スキルのタイトル
    String skillShortDescription() {return skillTitle() + "(" + int(cost()) + ")";}

    abstract Skill createSkill(CustomBreakout break_out, float x, float y); // スキルが発動されたら呼ばれる。x, yは発動が指示された座標
    float cost() { // スキル発動時に消費しなければいけないコスト。これを下回っていると発動できない。
        return 1;
    }
}
