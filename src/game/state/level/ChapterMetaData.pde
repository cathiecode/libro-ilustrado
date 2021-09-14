/*
 * ファイルの状態で格納されている各レベルを読み込むことなしに
 * とりあえずチャプターの情報を格納しておくクラス。
 * intoChapterDataEntity()で本読み込み。
 */
class ChapterMetaData extends ArrayList<String> {
    String title, background_path, audio_path;
    int chapter_number;

    ChapterMetaData(String title, String background_path, String audio_path) {
        this.title = title;
        this.background_path = background_path;
        this.audio_path = audio_path;
    }
    
    ChapterData intoChapterDataEntity() {
        ChapterData chapter_data = new ChapterData(this.title, background_path, audio_path, this);
        chapter_data.setChapterNumber(chapter_number);
        for (String level_location: this) { // レベルを全部ロードできるかやってみる
            chapter_data.add((new LevelLoader(level_location)).load());
        }
        return chapter_data;
    }

    // このチャプターが何番目かを設定する。
    // ChapterCompilationから呼び出され、セーブデータの管理に使われる。
    void setChapterNumber(int chapter_number) {
        this.chapter_number = chapter_number;
    }
}
