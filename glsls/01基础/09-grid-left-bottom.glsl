#ifdef GL_ES
precision mediump float;
#endif

// VISUALISING THE COORDINATE SYSTEM
//
// Let's use a for loop and horizontal and vertical lines to draw
// a grid of the coordinate center
void main() {
	vec2 r = vec2( gl_FragCoord.xy / iResolution.xy );
    float ratio = iResolution.x / iResolution.y;
	
	vec3 backgroundColor = vec3(1.0);
	vec3 axesColor = vec3(0.0, 0.0, 1.0);
	vec3 gridColor = vec3(0.5);

	// start by setting the background color. If pixel's value
	// is not overwritten later, this color will be displayed.
	vec3 pixel = backgroundColor;
	
	// Draw the grid lines
	// we used "const" because loop variables can only be manipulated
	// by constant expressions.
	const float tickXWidth = 0.1;
	float tickYWidth = tickXWidth * ratio;

	const float lineXWidth = 0.002;
	float lineYWidth = lineXWidth * ratio;
	for(float i=0.0; i<1.0; i+=tickXWidth) {
	  if(abs(r.x - i)<lineXWidth) pixel = gridColor;
	}
	for (float i = 0.0; i < 1.0; i+= tickYWidth) {
		if(abs(r.y - i)<lineYWidth) pixel = gridColor;
	}

	// Draw the axes
	if( abs(r.x)<lineXWidth ) pixel = axesColor;
	if( abs(r.y)<lineYWidth ) pixel = axesColor;
	
	gl_FragColor = vec4(pixel, 1.0);
}
