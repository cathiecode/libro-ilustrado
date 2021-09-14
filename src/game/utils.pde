// ちょっとおしゃれにタイマーを表示できるようにするやーつ
String timeMsToBePretty(float ms) {
    float as_sec = ms / 1000;
    float as_min = as_sec / 60;
    return String.format("%02d:%02d:%03d", floor(as_min), floor(as_sec % 60), floor(ms % 1000));
}
