import java.io.StringWriter;
import java.io.PrintWriter;

/*
 * ゲームの状態遷移すべてを司るクラス。GameStateとProcessingのPApplet(this)を受け取り生成される。
 * GameStateからGameStateへの遷移、ゲーム内時間の管理、グローバルオブジェクトの初期化を担当
 */
class GameMaster {
    ArrayList<GameState> state_stack = new ArrayList();        // 現在のState
    GameAudio audio;
    GameInputHandler input = new GameInputHandler();           // キー入力の取得をかんたんにするやつ
    private int last_updated_time_ms = millis();               // 前回updateが実行された時の時刻
    
    float frame_rate; // フレームレート

    boolean is_requested_finish_rendering = false; // 上流でレンダリングが停止されたかどうか

    GameMaster(GameState initial_state, PApplet _this, float _frame_rate) {
        audio = new GameAudio(_this);
        frame_rate = _frame_rate;
        _this.frameRate(_frame_rate);
        pushState(initial_state);
    }

    void handleDraw() {
        int now_time = millis(); // 現在の時間を取得
        float time_delta_ms = now_time - last_updated_time_ms; // 前回からの経過時間

        // フレームレートから考えられる許容範囲内の進行時間
        float safe_time_delta_ms = min(time_delta_ms, 1000 / frame_rate * 2);
        last_updated_time_ms = now_time; // 今回の時刻を記録

        for (int state_i = 0; state_i < state_stack.size(); state_i++) {
            state_stack.get(state_i).update(safe_time_delta_ms, state_i == state_stack.size() - 1);
        }

        // 入力のアップデート
        input.update();

        is_requested_finish_rendering = false;
        clear();
        int state_i = 0;
        for (GameState state: state_stack) {
            state.render();
            state_i++;
            if (is_requested_finish_rendering) break;
        }

        if (safe_time_delta_ms != time_delta_ms) { // フレームレートが維持できない場合に警告
            println("Can't keep up! time spike has been occured...");
            println("Delta time adjustment:", time_delta_ms, "to", safe_time_delta_ms);
        }
    }

    void finishRendering() { // render()中に下流のレンダリングを止めることができる。
        is_requested_finish_rendering = true;
    }

    void pushState(GameState new_state) { // ステートスタックにステートを追加
        state_stack.add(new_state);
        new_state.setGameMaster(this);
        new_state.onStateMount();
    }

    void popState() { // ステートスタックに最後に積まれたステートを除去
        GameState target = state_stack.get(state_stack.size() - 1);
        GameState removed_state = state_stack.remove(state_stack.size() - 1);

        if (state_stack.size() == 0) return;
        state_stack.get(state_stack.size() - 1).onBecameTop();
    }

    /*void changeState(GameState new_state) {
        state_stack.clear();
        pushState(new_state);
    }*/

    void replaceState(GameState new_state) { // ステートスタックに最後に積まれたステートを挿げ替え
        GameState target = state_stack.get(state_stack.size() - 1);
        GameState removed_state = state_stack.remove(state_stack.size() - 1);
        println("replaceState:", removed_state.getClass().getCanonicalName().toString());
        pushState(new_state);
    }

    void handleKeyPressed() { // 入力を受付
        input.handleKeyPressed(key);
    }

    void handleKeyReleased() {
        input.handleKeyReleased(key);
    }
    
    void handleMouseMoved() {
        input.handleMouseMoved();
    }

    void handleMousePressed() {
        input.handleMousePressed(mouseButton);
    }

    void handleMouseReleased() {
        input.handleMouseReleased(mouseButton);
    }

    UiManager createUiManager() { // UiManagerを作成(GameInputManagerが必要なのでここで)
        return new UiManager(this.input);
    }
}
