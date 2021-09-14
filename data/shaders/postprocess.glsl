#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    const vec4 bake_color = vec4(1.04, 1.03, 0.92, 1.0);

    vec4 orig_color = texture2D(texture, vertTexCoord.st);

    float center_distance = distance(vertTexCoord.st, vec2(0.5, 0.5));
    float vinnet_ratio = center_distance <= 0.5 ? 0.0 : (center_distance - 0.5) * 1.5;

    gl_FragColor = orig_color * (1.0 - vinnet_ratio) * bake_color;
}
