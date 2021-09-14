/*
 * レベルの開始時の演出。
 */
class LevelOpening extends GameState {
    float lifetime_ms = 0;

    void onStateMount() {
        lifetime_ms = 0;
    }

    void update(float time_delta_ms) {
        if (lifetime_ms >= 3000) {
            getGameMaster().popState();
        }
        lifetime_ms += time_delta_ms;
    }
}
