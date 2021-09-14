class GameAudio {
    PApplet p_applet_this;

    SoundFile bgm;

    float bgm_volume = 1.0;

    HashMap<String, SoundFile> sound_effects = new HashMap();

    GameAudio(PApplet _p_applet_this) {
        p_applet_this = _p_applet_this;
    }

    void playBgm(String path) {
        SoundFile new_bgm = AssetLoader.audio(path);
        if (new_bgm == bgm) return;
        if (bgm != null) {bgm.stop();}
        new_bgm.loop();
        bgm = new_bgm;
        bgm.amp(0.8);
        bgm_volume = 1.0;
    }

    void stopBgm() {
        if (bgm != null) {
            bgm.stop();
        }
    }

    void setBgmVolume(float ratio) {
        if (bgm_volume == ratio) return;
        if (bgm != null) {
            bgm.amp(ratio * 0.8);
        }
        bgm_volume = ratio;
    }

    void playSE(String path) {
        SoundFile sound_effect_or_null = sound_effects.get(path);
        if (sound_effect_or_null != null) {
            sound_effect_or_null.play();
        }

    }

    void loadSE(String path) {
        SoundFile sound_effect_or_null = sound_effects.get(path);
        if (sound_effect_or_null == null) {
            sound_effects.put(path, AssetLoader.audio(path));
        }
    }
}
