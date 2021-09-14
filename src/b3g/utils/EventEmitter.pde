/*
 * イベントが発生し、それをどこかに伝える必要があるときに使えるクラス。
 * イベント伝達先の具体的な型を知る必要がないので便利。
 * Tは伝えたい(送りたい)オブジェクトの型。enum推奨。
 */
class EventEmitter<T> {
    ArrayList<EventListener<T>> listeners = new ArrayList(); // イベントを待ち望んでいるオブジェクト

    // イベント内でイベントを呼び出すとConcurrentModificationなのを解決するもの
    ArrayList<T>     pending_events = new ArrayList();

    // イベントリスナを追加
    void registListener(EventListener<T> _listener) {
        listeners.add(_listener);
    }

    // イベントを発生させる(ただし、ConcurrentModification対策ですぐにはlistenerには伝えられない)
    void regist(T event) {
        pending_events.add(event);
    }

    // イベントをイベントリスナに伝える。このメソッドは、このEventEmitter由来のEventに由来する動作によって呼び出されるべきではない。
    // つまり、イベント処理とは全く関係ない、例えば定期的に呼び出されるメソッド内で呼び出されるべきである。
    void emit() {
        for (T event: pending_events) { // すべてのイベントをイベントリスナに伝達する
            for (EventListener<T> listener: listeners) {
                listener.receive(event);
            }
        }
        pending_events.clear(); // 発生待ちのイベントは消化したのでクリア
        
    }
}
