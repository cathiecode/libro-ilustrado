/*
 * 変更可能な値を持つクラス
 */
class Mutable<T> implements IGet<T> {
    T value;

    Mutable(T inital_value) {
        this.value = inital_value;
    }

    void mutate(T value) {
        this.value = value;
    }

    T get() {
        return value;
    }
}
