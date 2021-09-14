/*
 * ArrayList<T>の代替品。
 * forを回している最中にその中身をいじるといろいろと壊れる問題に対するWorkaroundを集めた物。
 * 入れたいものにEntityを実装して入れておけば要らなくなったときに勝手に除去してくれる。便利。
 * 本当はremoveIfとか使いたいけどProcessingはJava8のすべての機能には対応していない。辛い。
 */
class EntityManager<T extends Entity> extends ArrayList<T> {
    ArrayList<T> pending_additional_item = new ArrayList(); // 追加待ちのエンティティ

    // 安全に更新可能(たとえば、配列を舐めるようなループ内でない)ときに呼び出すと保留されていた操作が動く
    int applyPendingModifications() {
        int before_size = this.size();
        // 削除可能とマークされたものを削除する(触っている途中に後で触る要素がズレないように逆順で)
        for (int i = size() - 1; i >= 0; i--) {
            if (get(i).isRemovable()) {
                remove(i);
            }
        }

        // 追加待ちのエンティティがあれば挿入
        if (pending_additional_item.size() != 0) {
            this.addAll(pending_additional_item);
            pending_additional_item.clear();
        }

        return this.size() - before_size;
    }
    
    // 配列を舐めるような操作をしているときにConcurrentModificationが出ないように追加するメソッド。
    // 配列を抜けたときにapplyPendingModifications()を呼び出して操作を適用する必要がある。
    void addLater(T entity) {
        pending_additional_item.add(entity);
    }
}
