/*
 * フェードアウトを演出するState。次呼び出されるべきStateを受け取り、画面を暗くしてからそのStateに移行させる。
 */
class FadeOut extends GameState {
    GameState nextState;
    float time, power;
    FadeOut(GameState _nextState) {
        nextState = _nextState;
    }
    void onStateMount() {
        noStroke();
        time = 0;
    }
    void update(float time_delta_ms) {
        if (time >= 500) {
            game_master.replaceState(nextState);
            return;
        }
        power = time / 500;
        time += time_delta_ms;
    }

    void render() {
        beginCamera();
        ortho();
        pushMatrix();

        translate(0, 0, 100);

        fill(0, 0, 0, power * 255.0);
        rect(0, 0, width, height);

        popMatrix();
        endCamera();

        camera();
        perspective();
    }
}
