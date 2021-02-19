#ifdef GL_ES
precision mediump float;
#endif

#include "common/directionBlur.glsl"
#include "common/getProgress.glsl"

#iChannel0 "file://assets/vertical.jpg"

void main() {
  float progress = getProgress(iTime, 1.0);

  vec2 uv = gl_FragCoord.xy / iResolution.xy;

  float blurStep = (1.0 - progress) * 3.0;

  vec2 blurDirection = vec2(1.0, 0.0);

  vec4 resultColor =
      directionBlur(iChannel0, iResolution.xy, uv, blurDirection, blurStep);

  gl_FragColor = resultColor;
}
