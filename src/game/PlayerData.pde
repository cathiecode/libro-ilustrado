class PlayerData {
    int unlocked_index = 0;
    HashMap<Integer, ArrayList<ChapterClearState>> chapters_clear_states = new HashMap();

    void storeChapterClear(LevelState level_state) {
        if (!level_state.cleared) return;
        int chapter_number = level_state.chapter_data.chapter_number;
        if (chapters_clear_states.get(chapter_number) == null) {
            println("Reset chapter clear states");
            chapters_clear_states.put(chapter_number, new ArrayList());
        }
        ArrayList<ChapterClearState> chapter_clear_states = chapters_clear_states.get(chapter_number);
        chapter_clear_states.add(new ChapterClearState(getRankByLevelState(level_state), level_state.clear_time_ms));
    }

    JSONObject serialize() {
        JSONObject json = new JSONObject();

        json.setInt("unlocked_index", this.unlocked_index); // アンロック済みデータの読み出し
        
        JSONObject chapters_clear_states_json = new JSONObject();
        for (Integer chapter_index: chapters_clear_states.keySet()) {
            JSONArray chapter_clear_states_json = new JSONArray();
            ArrayList<ChapterClearState> chapter_clear_states = chapters_clear_states.get(chapter_index);
            for (ChapterClearState chapter_clear_state: chapter_clear_states) {
                chapter_clear_states_json.append(chapter_clear_state.serialize());
            }
            chapters_clear_states_json.setJSONArray(str(chapter_index), chapter_clear_states_json);
        }
        json.setJSONObject("chapters_clear_states", chapters_clear_states_json);

        return json;
    }

    ChapterClearState getBestChapterClearState(int chapter_id) {
        ArrayList<ChapterClearState> chapter_clear_states = chapters_clear_states.get(chapter_id);
        if (chapter_clear_states == null) return null;

        ChapterClearState best_chapter_clear_state = null;
        float best_chapter_clear_time = 100 * 60 * 1000; // 100min
        for (ChapterClearState chapter_clear_state: chapter_clear_states) {
            if (chapter_clear_state.clear_time_ms < best_chapter_clear_time) {
                best_chapter_clear_time = chapter_clear_state.clear_time_ms;
                best_chapter_clear_state = chapter_clear_state;
            }
        }
        if (best_chapter_clear_state == null) {
            return null;
        } else {
            return best_chapter_clear_state;
        }
    }
}