#ifdef GL_ES
precision mediump float;
#endif

// MAKING THE ASPECT RATIO OF THE COORDINATE SYSTEM 1.0
//
// As we have seen from the previous examples, we do get rectangles
// instead of squares when we plot the coordinate systems.
// It is because, we assigned same numerical interval, [0,1] to different
// physical distances. Actually the width of the frame is bigger 
// than of its height.
// So, to keep the aspect ratio, we should not map the actual distances
// [0, iResolution.x] and [0, iResolution.y] to the same interval.
void main() {
	vec2 r = vec2( gl_FragCoord.xy - 0.5*iResolution.xy );
	r = 2.0 * r.xy / iResolution.y;
	// instead of dividing r.x to iResolution.x and r.y to iResolution.y
	// divide both of them to iResolution.y.
	// This way r.y will be in [-1.0, 1.0]
	// and r.x will depend on the frame size. I guess the non-full screen
	// mode rx will be in [-1.78, 1.78], and in full screen mode
	// for my laptop, it will be in [-1.6, 1.6] (1440./900.=1.6)
	
	vec3 backgroundColor = vec3(1.0);
	vec3 axesColor = vec3(0.0, 0.0, 1.0);
	vec3 gridColor = vec3(0.5);

	vec3 pixel = backgroundColor;
	
	// Draw grid lines
	const float tickWidth = 0.1;
	for(float i=-2.0; i<2.0; i+=tickWidth) {
		// "i" is the line coordinate.
		if(abs(r.x - i)<0.004) pixel = gridColor;
		if(abs(r.y - i)<0.004) pixel = gridColor;
	}
	// Draw the axes
	if( abs(r.x)<0.006 ) pixel = axesColor;
	if( abs(r.y)<0.007 ) pixel = axesColor;
	
	gl_FragColor = vec4(pixel, 1.0);
}
