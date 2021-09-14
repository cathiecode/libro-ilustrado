/*
 * クリア時の「ランク」を表すクラス
 */
enum Rank {
    C("C", 0),
    B("B", 1),
    A("A", 2),
    S("S", 3);

    String rank_string;
    int    star_count;

    Rank(String rank_string, int star_count) {
        this.rank_string = rank_string;
        this.star_count  = star_count;
    }

    String getRankString() {
        return rank_string;
    }

    int getStarCount() { // 未使用、クリア時のランクを保持するようにしたら使うかも…
        return star_count;
    }
}

// クリア時のLevelStateからランクを計算
Rank getRankByLevelState(LevelState level_state) {
    if (!level_state.cleared) return Rank.C;
    float time_ratio = level_state.clear_time_ms / level_state.limit_time_ms;
    if (time_ratio <= 1.0/3) {
        return Rank.S;
    }
    if (time_ratio <= 2.0/3) {
        return Rank.A;
    }
    return Rank.B;
}

Rank getRankByLevelState(float clear_time_ms) {
    float time_ratio = clear_time_ms / (3 /* min is */ * 60 /* seconds is */ * 1000 /* milliseconds */);
    if (time_ratio <= 1.0/3) {
        return Rank.S;
    }
    if (time_ratio <= 2.0/3) {
        return Rank.A;
    }
    return Rank.B;
}