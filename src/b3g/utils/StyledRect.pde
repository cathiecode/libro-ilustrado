/*
 * 画像やrectなど四角形のものを表示させる際に、そのスタイル情報を入れておけるクラス
 */
abstract class StyledRect {
    abstract void render(float x, float y, float width, float height);
}
