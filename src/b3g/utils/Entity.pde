// EntityManagerで扱われるEntity。詳しくはEntityManagerへ
interface Entity {
    // 自分自身を配列から安全に取り除くことができるならtrue
    boolean isRemovable();
}
