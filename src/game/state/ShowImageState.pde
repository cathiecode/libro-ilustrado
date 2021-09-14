class ShowImageState extends GameState {
    UiManager ui_manager;
    GameState return_state;
    PImage page_image;

    ShowImageState(GameState return_state, PImage image) {
        this.return_state = return_state;
        this.page_image = image;
    }

    void onStateMount() {
        ui_manager = getGameMaster().createUiManager();
        ui_manager.addClickable(new BookmarkButton("back", "もどる", 140, height - 75, "red"));

        GameGlobal.background.nextPage();
    }

    void update(float time_delta_ms) {
        if (ui_manager.check_clicked() == "back") {
            getGameMaster().replaceState(return_state);
        }
    }

    void render() {
        image(page_image, 100, 50, 650, 860); // 750, 910
        ui_manager.render();
    }
}
