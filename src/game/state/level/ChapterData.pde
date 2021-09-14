/*
 * Levelをまとめてチャプターを構成するクラス。chapter_numberが正しく設定されていないと
 * セーブデータが壊れる。
 */
class ChapterData extends ArrayList<LevelData> {
    String title, background, audio;
    int chapter_number;
    ChapterMetaData meta_data;

    ChapterData(String title, String background, String audio, ChapterMetaData meta_data) {
        this.title = title;
        this.background = background;
        this.audio = audio;
        this.meta_data = meta_data;
    }

    void setChapterNumber(int chapter_number) {
        this.chapter_number = chapter_number;
    }
}
