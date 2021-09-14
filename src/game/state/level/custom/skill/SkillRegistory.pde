/*
 * スキルの一覧の対応表を持っているクラス。インベントリのロードとかに使う。
 */
class SkillRegistory {
    HashMap<String, SkillFactory> skill_by_id = new HashMap();
    HashMap<Class, String> id_by_skill_class = new HashMap();
    ArrayList<SkillFactory> skill_by_order = new ArrayList();

    SkillRegistory() {
        regist("BEAM", new BeamSkillFactory());
        regist("FLARE", new FlareSkillFactory());
        regist("FIXED_GUN", new FixedGunFactory());
        
        regist("SAFETY_NET", new SafetyNetSkillFactory());
        regist("PSEUDO_BLOCK_SKILL", new PseudoBlockSkillFactory());
        regist("VACUUM", new VacuumSkillFactory());
    }

    void regist(String id, SkillFactory skill_factory) { //  新スキルの登録
        skill_by_id.put(id, skill_factory);
        id_by_skill_class.put(skill_factory.getClass(), id);
        skill_by_order.add(skill_factory);
    }

    SkillFactory getSkillFactoryById(String id) { // スキルIDからSkillFactoryを取得
        return skill_by_id.get(id);
    }

    String getIdBySkillFactory(SkillFactory skill_factory) { // SkillFactoryからスキルIDを取得
        return id_by_skill_class.get(skill_factory.getClass());
    }
}
