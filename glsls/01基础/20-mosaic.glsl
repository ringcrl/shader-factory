#ifdef GL_ES
precision mediump float;
#endif

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {
    vec2 st = gl_FragCoord.xy/iResolution.xy;

    st *= 10.0; // 造个10*10格子
    vec2 ipos = floor(st);  // 获取整数坐标
    vec2 fpos = fract(st);  // 获取分数坐标

    // 根据整数坐标绘图
    vec3 color = vec3(random( ipos ));

    // Uncomment to see the subdivided grid
    // color = vec3(fpos,0.0);

    gl_FragColor = vec4(color,1.0);
}
