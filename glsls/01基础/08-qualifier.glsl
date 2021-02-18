#ifdef GL_ES
precision mediump float;
#endif

vec4 generateColor(
  in float r, // 只读
  out float g, // 只写
  inout float b, // 读写
  inout float a, // 读写
) {
  return vec4(r, g, b, a);
}

// 1、有一个 main 函数，会在最后返回颜色值
// 2、最终的像素颜色取决于预设的全局变量 gl_FragColor
void main() {
	gl_FragColor = generateColor(1.0, 0.0, 0.0, 1.0);
}
