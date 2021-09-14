/*
 * ゲームのフロー(Title, Ingame, Pauseなど)を表すメソッド。
 * 一画面に1つ作っておくとスマートに状態を遷移させることができる。
*/
class GameState {
    GameMaster game_master;

    // ゲームマスター側から呼ばれるやつ。
    void setGameMaster(GameMaster _game_master) {
        game_master = _game_master;
    }

    // ステート側からGameMasterを見やすくするために実装。
    GameMaster getGameMaster() {
        return game_master;
    }

    // 状態が開始されたときに呼ばれるメソッド
    void onStateMount() {}

    // popStateなどでステートが一番上になったときに呼ばれるメソッド。Deprecated。
    void onBecameTop() {}

    // is_topがいらないクラス用
    void update(float time_delta_ms) {}

    // GameMasterから毎フレーム呼び出されるメソッド。状態の更新を扱う。
    void update(float time_delta_ms, boolean is_top) {
        update(time_delta_ms); // is_topがいらないクラス用
    }

    // GameMasterから毎フレーム呼び出されるメソッド。レンダリングを扱う。
    void render() {}
}
