#ifdef GL_ES
precision mediump float;
#endif

#iChannel0 "file://assets/vertical.jpg"
#iChannel1 "file://assets/vertical2.jpg"

#include "common/bezierEffect.glsl"
#include "common/getProgress.glsl"

vec2 direction = vec2(1.0, 0.0);

void main() {
  float progress = getProgress(iTime, 2.0);
  vec2 uv = gl_FragCoord.xy / iResolution.xy;

  float time = easeInOutQuint(progress);
  vec2 p = uv + time * sign(direction);
  vec2 f = fract(p);
  vec4 fromTex = texture2D(iChannel0, f);
  vec4 toTex = texture2D(iChannel1, f);
  vec3 res =
      mix(toTex.rgb, fromTex.rgb,
          step(0.0, p.y) * step(p.y, 1.0) * step(0.0, p.x) * step(p.x, 1.0));

  gl_FragColor = vec4(res, 1.0);
}
