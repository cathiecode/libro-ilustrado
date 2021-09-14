    class ChapterClearState {
        Rank rank;
        float clear_time_ms;

        ChapterClearState(Rank rank, float clear_time_ms) {
            this.rank = rank;
            this.clear_time_ms = clear_time_ms;
        }

        JSONObject serialize() {
            JSONObject json = new JSONObject();
            
            json.setFloat("clear_time_ms", clear_time_ms);

            return json;
        }
    }