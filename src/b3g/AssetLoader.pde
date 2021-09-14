import processing.sound.*;

/*
 * キャッシュ付きのloadなんたら関数みたいなもの
 */
AssetLoaderClass AssetLoader = new AssetLoaderClass(this);

class AssetLoaderClass {
    PApplet p_applet_this;

    HashMap<String, PImage> images = new HashMap(); // キャッシュ
    HashMap<String, SoundFile> sounds = new HashMap();

    AssetLoaderClass(PApplet p_applet_this) {
        this.p_applet_this = p_applet_this;
    }

    PImage image(String path) {
        PImage cache_or_null = images.get(path);
        if (cache_or_null != null) {
            return cache_or_null;
        }

        println("loading", path);

        PImage loaded_image = loadImage(path);
        images.put(path, loaded_image); // キャッシュに入れておく
        return loaded_image;
    }

    SoundFile audio(String path) {
        SoundFile sound_or_null = sounds.get(path);
        if (sound_or_null != null) {
            return sound_or_null;
        }
        SoundFile sound = new SoundFile(this.p_applet_this, path);
        sounds.put(path, sound);
        return sound;
    }

    void clear() { // キャッシュクリア
        images.clear();
        sounds.clear();
    }
}