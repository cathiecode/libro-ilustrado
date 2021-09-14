/*
 * チャプターのプレイ状況を保持
 */
class LevelState {
    boolean cleared = false;  // その試行でクリア済み？
    boolean failed  = false;  // その試行は失敗した？お
    float limit_time_ms;      // 制限時間
    float play_time_ms;       // プレイ時間
    float clear_time_ms;      // クリアタイム
    ChapterData chapter_data; // チャプターデータ

    // クリアしたときにクリアタイムと一緒に呼ぶとクリア関連の変数をまとめて更新できる
    void clear(float clear_time_ms) { 
        this.cleared = true;
        this.clear_time_ms = clear_time_ms;
    }

    // 残り時間を計算
    float remainTimeMs() {
        if (cleared) {
            return limit_time_ms - clear_time_ms;
        } else {
            return limit_time_ms - play_time_ms;
        }
    }

    void setPlaytime(float play_time_ms) {
        this.play_time_ms = min(limit_time_ms, play_time_ms);
        if (this.play_time_ms == limit_time_ms) {
            this.failed = true;
        }
    }
}
