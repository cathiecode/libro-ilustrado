
class DebugLayerState extends GameState {
    boolean debug_frag = false;

    GameState child_state;

    PFont font = createFont("Monospaced", 16);

    float[] time_delta_history = new float[300];
    int time_delta_history_pointer = 0;

    IntervalTimer infoPrinterTimer = new IntervalTimer(1000.0 / 15.0); // FPS等のデバッグ情報を見せるためのタイマー

    DebugLayerState(GameState child_state) {
        this.child_state = child_state;
    }

    void onStateMount() {
        getGameMaster().pushState(child_state);
    }

    void onBecameTop() {
        getGameMaster().popState();
    }

    float prev_time = millis();

    void update(float game_master_time_delta_ms) {
        float now_time = millis();
        float time_delta_ms = now_time - prev_time;
        if (getGameMaster().input.keyOneshot('-')) debug_frag = !debug_frag;
        if (debug_frag) {
            if (getGameMaster().input.keyOneshot('0')) testFunctions();
            if (infoPrinterTimer.check_and_reset(time_delta_ms)) { // デバッグメッセージ
                startdbg();
                dbg("Version          :", VERSION);
                dbg("Time delta       :", time_delta_ms + "ms");
                dbg("System frame rate:", frameRate + "fps");
                dbg("Mouse            :", mouseX, mouseY, mousePressed);
                dbg();
                dbg("[State stack]");
                for (int i = 0; i < getGameMaster().state_stack.size(); i++) {
                    String state_name = getGameMaster().state_stack.get(i).getClass().getCanonicalName().toString();
                    dbg(" ", i, state_name);
                }
            }
            time_delta_history[time_delta_history_pointer] = time_delta_ms;
            if (++time_delta_history_pointer >= time_delta_history.length) {
                time_delta_history_pointer = 0;
            }
        }
        prev_time = now_time;
    }

    void render() {
        if (!debug_frag) return;
        beginCamera();
        ortho();
        pushMatrix();

        textFont(font, 16);
        textAlign(LEFT, TOP);

        translate(0, 0, 100);

        for (int i = 0; i < debug_message.size(); i++) {
            debugtext(debug_message.get(i), 0, 24 * i);
        }

        float spike_index = 0, spike_time_delta = 0;
        for (int i = 0; i < time_delta_history.length; i++) {
            stroke(lerpColor(#00ff00, #ff0000, min(1.0, time_delta_history[i] / 100.0)));
            line(i, height - time_delta_history[i], i, height);
            if (time_delta_history[i] > spike_time_delta) {
                spike_index = i;
                spike_time_delta = time_delta_history[i];
            }
        }
        if (spike_time_delta >= 1000.0 / 30.0) {
            debugtext(spike_time_delta + "ms", spike_index, height - constrain(spike_time_delta, 50, 150));
        }

        stroke(#0000ff);
        line(time_delta_history_pointer + 1, height - time_delta_history[time_delta_history_pointer], time_delta_history_pointer + 1, height);

        popMatrix();
        endCamera();

        camera();
        perspective();
    }

    ArrayList<String> debug_message = new ArrayList();
    void startdbg() {
        debug_message.clear();
    }
    void dbg(Object... texts) {
        String debug_message_line = "";
        for (Object text_object: texts) {
            debug_message_line += text_object.toString() + " ";
        }
        debug_message_line += "\n";
        debug_message.add(debug_message_line);
    }

    void dbg() {
        debug_message.add("");
    }

    void debugtext(String text, float x, float y) {
            textFont(font);
            textAlign(LEFT, TOP);
            noStroke();
            fill(#000000);
            rect(x, y, textWidth(text), 24);

            fill(#ffffff);
            text(text, x, y);

    }

    void testFunctions() {
        println("--- Start function tests ---");
        println("--- End of function tests ---");
    }
}