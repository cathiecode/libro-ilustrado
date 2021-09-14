class BlendedGrayImage {
    PImage image, image_gray;
    BlendedGrayImage(String image_path) {
        image = loadImage(image_path);
        image_gray = loadImage(image_path);
        image_gray.filter(GRAY);
    }

    void render(float x, float y, float width, float height, float ratio) {
        if (ratio < 0.99) {
            noTint();
            image(image, x, y, width, height);
        }
        tint(255, ratio * 255.0);
        image(image_gray, x, y, width, height);
        noTint();
    }
}