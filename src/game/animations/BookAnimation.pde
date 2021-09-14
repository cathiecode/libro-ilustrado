/*
 * 背景の本。
 */
class BookAnimation extends JointAnimationRoot {
    // 本のページ
    class Paper extends JointAnimationNode {
        float ratio = 0; // 開き具合
        float next_ratio = 0; // 次の開き具合。アニメーション用。
        float ratio_delta_per_ms = 0; // 1秒にどれくらい開くか
        float page_offset_ratio = 0;  // ページを表紙からどれくらい離すか

        Paper(float width, float height, float page_offset_ratio) {
            super();
            setSize(width, height);
            setOrigin(0, height / 2, 0);
            setNodeImage(new TextureStyledRect("assets/page.png"));

            ratio = 0.5;
            next_ratio = 0.5;
            this.page_offset_ratio = page_offset_ratio;
        }

        void update(float time_delta_ms) {
            if (abs(next_ratio - ratio) >= abs(ratio_delta_per_ms * time_delta_ms)) { // 十分開くまでratioを動かす
                ratio += ratio_delta_per_ms * time_delta_ms;
            } else {
                ratio = next_ratio; // 十分近づいたらそのまま代入してアニメーション終了
            }
        }

        void setAngle(float next_ratio) { // 0-1 開き具合を設定
            ratio_delta_per_ms = (next_ratio - ratio) / 1000;
            this.next_ratio = next_ratio;
        }

        void applySelfTransform() {
            translate(0.0, 0.0, calcOffset(ratio) * -10);
            rotateY(ratio * PI * -1 + PI);
        }

        /*
         * これは、ページそのものの高さを計算する関数である。
         * 何故これが必要なのかというと、ページが重ならないようにするためである。
         * ページを開いた横書きの本を考えたときに、左右のページの高さを考えてみると、
         * 本の最初の方では左ページが低く、右ページが高い。
         * 終盤に差し掛かると、それが逆になる。
         * そういった挙動を実現するための関数である。
         * マジックナンバーの0.01は、表紙とページが重なって見えないようにするための措置。
         */
        float calcOffset(float ratio) { // オフセットを計算
            if (ratio <= 0.5) { // ページが半分以上開いているかどうか
                float half_ratio = ratio * 2;
                return ((1 - page_offset_ratio) * (1 - half_ratio) + 1.0 * half_ratio) + 0.01;
            } else { // ratio > 0.5
                float half_ratio = (ratio - 0.5) * 2;
                return (1 * (1 - half_ratio) + page_offset_ratio * half_ratio) + 0.01;
            }
        }
    }

    // 本のカバー。動きはだいたいPaperと同じなのでコメントは省略。
    class Cover extends JointAnimationNode {
        float ratio = 0; // ここらへんはPaperとおなじ
        float next_ratio = 0;
        float ratio_delta_per_ms = 0;

        Cover(float width, float height) {
            super();
            setSize(width, height);
            setOrigin(0, height / 2, 0);
            setNodeImage(new TextureStyledRect("assets/cover.png"));
        }

        void update(float time_delta_ms) {
            if (abs(next_ratio - ratio) >= abs(ratio_delta_per_ms * time_delta_ms)) {
                ratio += ratio_delta_per_ms * time_delta_ms;
            } else {
                ratio = next_ratio;
            }
        }

        void setAngle(float next_ratio) { // 0-1
            ratio_delta_per_ms = (next_ratio - ratio) / 1000;
            this.next_ratio = next_ratio;
        }

        void applySelfTransform() {
            rotateY(ratio * PI * 0.5 + PI * 0.5);
        }
    }

    // 本の背中
    class Spine extends JointAnimationNode {
        float ratio = 0;
        float next_ratio = 0;
        float ratio_delta_per_ms = 0;

        Spine(float width, float height) {
            super();
            setSize(width, height);
            setOrigin(width / 2, height / 2, 0);
            setNodeImage(new PrimitiveStyledRect(new DrawStyle(#2e3147)));
        }

        void update(float time_delta_ms) {
            if (abs(next_ratio - ratio) >= abs(ratio_delta_per_ms * time_delta_ms)) {
                ratio += ratio_delta_per_ms * time_delta_ms;
            } else {
                ratio = next_ratio;
            }
        }

        void setAngle(float next_ratio) { // 0-1
            ratio_delta_per_ms = (next_ratio - ratio) / 1000;
            this.next_ratio = next_ratio;
        }

        void applySelfTransform() {
            rotateY(ratio * PI * -1 - PI / 2);
        }
    }

    Spine spine; // 背中
    Cover head_cover, behind_cover; // カバー
    int current_open_page = 0; // 現在開かれているページ
    ArrayList<Paper> papers = new ArrayList(); // 紙など

    BookAnimation(float x, float y, int page_num) {
        setOffset(x, y);

        spine = new Spine(60, 920);

        head_cover = new Cover(710, 920);
        head_cover.setOffset(-30, 0, 0);

        behind_cover = new Cover(710, 920);
        behind_cover.setOffset(30, 0, 0);

        // JointAnimationRootの子として追加
        children.add(spine);
        spine.children.add(head_cover);
        spine.children.add(behind_cover);

        // 紙をまとめて追加。
        for (int i = 0; i < page_num; i++) {
            Paper paper = new Paper(680, 890, float(i) / (float(page_num) - 1));
            paper.setOffset(0, 0, 10);
            papers.add(paper);
            spine.children.add(paper);
        }
    }

    // 表紙側に本を閉じる
    void closeToHead() {
        spine.setAngle(0.0);
        head_cover.setAngle(0.0);
        behind_cover.setAngle(0.0);
        for (Paper paper: papers) { // すべての紙を閉じる
            paper.setAngle(0.5);
        }
    }

    // 背表紙側に本を閉じる
    void closeToBehind() {
        spine.setAngle(1.0);
        head_cover.setAngle(0.0);
        behind_cover.setAngle(0.0);
        for (Paper paper: papers) { // すべての紙を閉じる
            paper.setAngle(0.5);
        }
    }

    // 指定されたページを開く
    void openPage(int page_num) {
        spine.setAngle(0.5);
        head_cover.setAngle(1.0);
        behind_cover.setAngle(-1.0);
        
        int i = 0;
        for (; i <= page_num && i < papers.size(); i++) { // 指定されたページより前は左側へ
            papers.get(i).setAngle(1.0);
        }
        for (; i < papers.size(); i++) { // そのあとのページは右側へ
            papers.get(i).setAngle(0.0);
        }
        current_open_page = page_num;
    }

    void nextPage() { // 次のページを開く
        openPage(++current_open_page);
    }

    boolean update(float time_delta_ms) {
        return super.update(time_delta_ms);
    }
    void render() {
        super.render();
    }
}
