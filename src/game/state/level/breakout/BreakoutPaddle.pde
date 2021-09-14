class BreakoutPaddle extends BreakoutMovableObject {
    BreakoutPaddle(float _x, float _y, float _width, float _height, StyledRect styled_rect) {
        super(_x, _y, _width, _height, styled_rect);
    }

    // ボールが当たった場所によって挙動を変える
    boolean applyBallHit(BreakoutBall ball) {
        if (!isCollideWith(ball)) {
            return false;
        }
        float ball_relative_x = x - ball.x;

        // -0.5 <= ball_relative_x / width <= 0.5 なので、最大±45°で打ち返すことになる
        float new_direction = atan(ball_relative_x / width) * -1 + HALF_PI * 3;

        // もとのボールの速度に直してあげる
        float speed = sqrt(pow(ball.dx, 2) + pow(ball.dy, 2));
        float new_dx = cos(new_direction) * speed;
        float new_dy = sin(new_direction) * speed;

        ball.set_speed(new_dx, new_dy);
        return true;
    }
}
