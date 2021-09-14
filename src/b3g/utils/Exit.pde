/*
 * ゲームを終了させるためのState。べつに各々でexit()呼び出すのと同じなのですが精神衛生上良くないので一応。
 */
class Exit extends GameState {
    void onStateMount() {
        println("Exit");
        exit();
    }
}
