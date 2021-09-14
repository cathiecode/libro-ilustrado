/*
 * レベルデータ(levels/以下)を読み込むためのパーサーっぽいもの
 */
class LevelLoader {
    String file_path;

    LevelLoader(String _file_path) {
        file_path = _file_path;
    }
    
    LevelData load() {
        String[] lines = loadStrings(file_path); // まずは読み込む
        LevelData level_data = new LevelData(); // これに情報を詰め込んでいく
        
        int line_number = 0;
        for (String line: lines) {
            if (line_number == 0) { // 1行目(タイトル)
                level_data.title = line;
            }
            else if (line_number == 1) { // 2行目(サイズ,...)
                String[] tokens = line.split(",");
                level_data.size          = int(tokens[0]);
                level_data.limit_time_ms = int(tokens[1]);
            }
            else if (line_number >= 2) { // それ以降(ステージデータの文字列)
                level_data.block_lines.add(readBlockLineString(line));
            }
            line_number++;
        }
        return level_data;
    }

    // ブロックの行を読み込んで配列に詰め込んでくれるメソッド
    private ArrayList<BlockType> readBlockLineString(String line_string) {
        ArrayList<BlockType> blocks = new ArrayList();

        // 1文字ずつ見てblocksの該当する場所にBlockTypeをあてはめていく
        int char_number = 0;
        for (String character: line_string.split("")) {
            blocks.add(blockCharacterToBlockType(character));
            char_number++;
        }
        return blocks;
    }

    // 指定された文字から内部形式に変換してくれるメソッド
    private BlockType blockCharacterToBlockType(String character) {
        switch (character) {
            case "N":
                return BlockType.NORMAL;
            case "H":
                return BlockType.HARD;
            case "S":
                return BlockType.SPAWNER;
            case "B":
                return BlockType.BOSS;
            default:
                return BlockType.AIR;
        }
    }
}
