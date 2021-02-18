#ifdef GL_ES
precision mediump float;
#endif

// MOVING THE COORDINATE CENTER TO THE CENTER OF THE FRAME
//
// Instead of mapping [0, iResolution.x]x[0, iResolution.y] region to
// [0,1]x[0,1], lets map it to [-1,1]x[-1,1]. This way the coordinate
// (0,0) will not be at the lower left corner of the screen, but in the
// middle of the screen.
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float ratio = iResolution.x / iResolution.y;

	vec2 r = vec2( fragCoord.xy - 0.5*iResolution.xy );
	// [0, iResolution.x] -> [-0.5*iResolution.x, 0.5*iResolution.x]
	// [0, iResolution.y] -> [-0.5*iResolution.y, 0.5*iResolution.y]
	r = 2.0 * r.xy / iResolution.xy;
	// [-0.5*iResolution.x, 0.5*iResolution.x] -> [-1.0, 1.0]
	
	vec3 backgroundColor = vec3(1.0);
	vec3 axesColor = vec3(0.0, 0.0, 1.0);
	vec3 gridColor = vec3(0.5);

	// start by setting the background color. If pixel's value
	// is not overwritten later, this color will be displayed.
	vec3 pixel = backgroundColor;
	
	// Draw the grid lines
	// This time instead of going over a loop for every pixel
	// we'll use mod operation to achieve the same result
	// with a single calculation (thanks to mikatalk)
	const float tickXWidth = 0.1;
	float tickYWidth = tickXWidth * ratio;
	float lineXWidth = 0.008;
	float lineYWidth = lineXWidth * ratio;
	if( mod(r.x, tickXWidth) < lineXWidth ) pixel = gridColor;
	if( mod(r.y, tickYWidth) < lineYWidth ) pixel = gridColor;
	// Draw the axes
	if( abs(r.x)<lineXWidth ) pixel = axesColor;
	if( abs(r.y)<lineYWidth ) pixel = axesColor;
	
	fragColor = vec4(pixel, 1.0);
}
