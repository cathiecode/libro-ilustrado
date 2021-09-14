String SAVE_DATA_PATH = "save/player_data.json";

// プレイヤーデータのロード
PlayerData loadPlayerData() {
    PlayerData player_data = new PlayerData();
    JSONObject json;
    try {
        json = loadJSONObject(SAVE_DATA_PATH); // ロードを試す
    } catch(Exception e) {
        return player_data; // データが読み出せなかったら新規で
    }

    player_data.unlocked_index = json.getInt("unlocked_index"); // アンロック済みデータの読み出し

    JSONObject chapters_clear_states_json = json.getJSONObject("chapters_clear_states");

    for (Object chapter_id: chapters_clear_states_json.keys()) {
        JSONArray chapter_clear_states_json = chapters_clear_states_json.getJSONArray((String)chapter_id);
        ArrayList<ChapterClearState> chapter_clear_states = new ArrayList();
        for (int i = 0; i < chapter_clear_states_json.size(); i++) {
            JSONObject chapter_clear_state_json = chapter_clear_states_json.getJSONObject(i);
            float clear_time_ms = chapter_clear_state_json.getFloat("clear_time_ms");
            chapter_clear_states.add(new ChapterClearState(getRankByLevelState(clear_time_ms), clear_time_ms));
        }
        player_data.chapters_clear_states.put(int((String)chapter_id), chapter_clear_states);
    }
    

    return player_data;
}

// プレイヤーデータのセーブ
void savePlayerData(PlayerData player_data) {
    saveJSONObject(player_data.serialize(), SAVE_DATA_PATH); // 保存
}