#ifdef GL_ES
precision mediump float;
#endif

void main() {
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    st.x *= iResolution.x/iResolution.y;

    vec3 color = vec3(.0);

    // 单元位置
    vec2 point[5];
    point[0] = vec2(0.83,0.75);
    point[1] = vec2(0.60,0.07);
    point[2] = vec2(0.28,0.64);
    point[3] = vec2(0.31,0.26);
    point[4] = iMouse.xy/iResolution.xy;

    float m_dist = 1.;  // 最小距离

    // 遍历所有点的位置
    for (int i = 0; i < 5; i++) {
        float dist = distance(st, point[i]);

        // 保持更近的距离
        m_dist = min(m_dist, dist);
    }

    // 画出最小距离（距离场）
    color += m_dist;

    // Show isolines
    // color -= step(.7,abs(sin(50.0*m_dist)))*.3;

    gl_FragColor = vec4(color,1.0);
}