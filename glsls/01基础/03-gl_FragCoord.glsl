#ifdef GL_ES
precision mediump float;
#endif

// 默认输出值 vec4 gl_FragColor：输出颜色
// 默认输入值 vec4 gl_FragCoord：输入正在处理的坐标，是个 varying（变化值），不是 uniform（统一值）

void main() {
	// 单位化的坐标系变量 (st) 是 0.0 到 1.0 之间的值
	vec2 st = gl_FragCoord.xy / iResolution.xy;
	gl_FragColor = vec4(st.x, st.y, 0.0,1.0);
}
