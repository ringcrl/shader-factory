// sqrt()函数，以及所有依赖它的运算，都耗时耗力
// dot()点乘是另外一种用来高效计算圆形距离场的方式

#ifdef GL_ES
precision mediump float;
#endif

float circle(in vec2 _st, in float _radius){
	vec2 dist = _st - vec2(0.5);
	return smoothstep(
		_radius-(_radius*0.01),
		_radius+(_radius*0.01),
		dot(dist,dist)*4.0
	);
}

void main(){
	vec2 st = gl_FragCoord.xy/iResolution.xy;

	vec3 color = vec3(circle(st,0.5));

	gl_FragColor = vec4( color, 1.0 );
}
