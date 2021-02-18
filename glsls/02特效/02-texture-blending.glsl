#iChannel0 "file://assets/wood-background.jpg"
#iChannel1 "file://assets/a.png"

void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    vec3 pattern = texture2D(iChannel0, uv).rgb;
    float mask = texture2D(iChannel1, uv).a;

    vec3 maskedPattern = pattern * mask;
    gl_FragColor = vec4(maskedPattern, 1.0);
}
