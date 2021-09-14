/*
 * もっとも一般的なブロック。動かない。
 */
class BreakoutNormalBlock extends BreakoutBlock {
    BreakoutNormalBlock(float _x, float _y, float _width, float _height) {
        super(_x, _y, _width, _height, new TextureStyledRect("assets/normal_block.png"));
    }
}
