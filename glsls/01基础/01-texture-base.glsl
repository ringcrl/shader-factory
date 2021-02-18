#iChannel0 "file://assets/duck.jpeg"

void main() {
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.x += 0.05 * sin(iTime + uv.y * 10.0);
    vec4 color = texture(iChannel0, uv);
    gl_FragColor = color;
}