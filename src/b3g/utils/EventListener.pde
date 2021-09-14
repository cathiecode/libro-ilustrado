/*
 * EventEmitterのイベントを心待ちにするオブジェクトを表すクラス。
 * EventEmitterに登録されるとemit()された時点でEventが発生したことを知ることができる。
 * receive()は溜まっていたイベントが消化されるまで繰り返し呼び出される。
 */

interface EventListener<T> {
    void receive(T event);
}
