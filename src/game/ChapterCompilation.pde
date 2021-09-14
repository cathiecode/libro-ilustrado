/*
 * チャプターの編纂
 */
class ChapterCompilation extends ArrayList<ChapterMetaData> {
    boolean add(ChapterMetaData chapter_meta_data) {
        chapter_meta_data.setChapterNumber(this.size()); // セーブデータ用にチャプターの数値を入れておく
        return super.add(chapter_meta_data);
    }
}
