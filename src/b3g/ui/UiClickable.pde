abstract class UiClickable extends Aabb {
    String id; // クリックされたときに判別するためのID

    UiClickable(String id) {
        this.id = id;
    }

    abstract void render(boolean is_hovered, boolean is_pushed);
}
