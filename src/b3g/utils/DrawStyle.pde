/*
 * DrawStyle クラス
 * noStroke(), noFill(), stroke([color]), fill([color]) をまとめて呼び出せるクラス。
 * 描画方法を指定しておきたいクラスに持たせておくといちいち4つの要素を記憶した上でメソッドを呼び出さなくて済む。
 */
class DrawStyle {
    color stroke_color = #000000, fill_color = #000000;
    boolean no_stroke = true;
    boolean no_fill = true;

    // 透明で描画される
    DrawStyle() {

    }

    // fill以外は透明で
    DrawStyle(color _fill_color) {
        setFill(_fill_color);
    }

    // strokeとfillを同時に指定できるコンストラクタ。
    DrawStyle(color _stroke_color, color _fill_color) {
        setStroke(_stroke_color);
        setFill(_fill_color);
    }

    // strokeの色を指定(noStrokeは解除される)
    DrawStyle setStroke(color _stroke) {
        stroke_color = _stroke;
        no_stroke = false;
        return this;
    }

    // fillの色を指定(noFillは解除される)
    DrawStyle setFill(color _fill) {
        fill_color = _fill;
        no_fill = false;
        return this;
    }

    // 指定された内容でnoStroke, noFill, stroke, fill
    void apply() {
        if (no_stroke) {
            noStroke();
        } else {
            stroke(stroke_color);
        }
        if (no_fill) {
            noFill();
        } else {
            fill(fill_color);
        }
    }
}
