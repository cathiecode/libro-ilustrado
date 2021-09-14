/*
 * レベルデータを表すクラス
 * NOTE: じつはblock_lines以外もう使っていない
 */
class LevelData {
    String title;
    int size; // 横幅
    float limit_time_ms; // Deprecated: 制限時間
    ArrayList<ArrayList<BlockType>> block_lines = new ArrayList(); // ブロックの配列
}
