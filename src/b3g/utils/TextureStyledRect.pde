/*
 * テクスチャ画像で装飾されたStyledRect
 */
class TextureStyledRect extends StyledRect {
    PImage image;
    TextureStyledRect(PImage _image) {
        image = _image;
    }
    TextureStyledRect(String texture_file) {
        image = AssetLoader.image(texture_file);
    }
    void render(float x, float y, float width, float height) {
        if (image == null) return; // loadImageしてもnullになってることがあるっぽいから一応対応
        image(image, x, y, width, height);
    }
}
