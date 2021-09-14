class WaitTitleAssetLoading extends GameState {
    GameState title;
    WaitTitleAssetLoading(GameState title) {
        this.title = title;
    }
    void update(float time_delta_ms) {
        if (isTitleAssetsPreloaded) {
            getGameMaster().replaceState(this.title);
        }
    }

    void render() {
        textAlign(CENTER, CENTER);
        text("Loading...", width / 2, height / 2);
    }
}