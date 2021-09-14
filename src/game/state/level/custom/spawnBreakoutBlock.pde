/*
 * Breakoutにレベルデータをもとにブロックを詰めていくメソッド。
 * どこに置けばいいかわからなかったのでとりあえずただの関数としておいておく。
 */
void spawnBreakoutBlock(Breakout break_out, LevelData level_data) {
    float block_width =  break_out.stage_width  / level_data.size; // ブロックの横幅
    float block_height = block_width; // ブロックの縦の長さ

    // 中心座標で指定するので先にずらしておく
    float origin_x = block_width / 2;
    float origin_y = block_width / 2;

    // レベルデータが配列で納品されるのでループでステージに追加していく
    float y = origin_y;
    for (ArrayList<BlockType> line: level_data.block_lines) { // 行ごとに…
        float x = origin_x;
        for (BlockType block_type: line) {// 指定されたブロックをひとつづつaddしてゆく
            switch (block_type) {
                case NORMAL:
                    break_out.blocks.add(new BreakoutNormalBlock(x, y, block_width, block_height)); // 普通のブロック
                    break;
                case SPAWNER:
                    break_out.blocks.add(new BreakoutBlockSpawner(x, y, block_width, block_height, 5, break_out)); // ブロックを出す敵
                    break;
                case BOSS:
                    break_out.blocks.add(new BreakoutBoss(x, y, block_width, block_height, break_out)); // ボス
                    break;
                case AIR: // 何もない場所
                    break;
                default:
                    println("!-- Undefined block"); // 不明なブロックがあったら警告
            }
            x += block_width;
        }
        y += block_height;
    }
}
