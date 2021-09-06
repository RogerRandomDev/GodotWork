shader_type canvas_item;
uniform float tape_wave_amount :hint_range (0, .04) = 0.002;
uniform float tape_crease_amount :hint_range (0, 15) = 0.25;
uniform float color_displacement :hint_range (0, 5) = 0.0;
uniform float lines_velocity :hint_range (0, 5) = 0.075;
const float PI = 3.14159265359;
uniform vec2 screen_size = vec2(320.0, 180.0);
uniform bool show_curvature = true;
uniform float curvature_x_amount : hint_range(3.0, 15.0, 0.01) = float(6.0); 
uniform float curvature_y_amount : hint_range(3.0, 15.0, 0.01) = float(4.0);
uniform vec4 corner_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool show_vignette = true;
uniform float vignette_opacity : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform bool show_horizontal_scan_lines = true;
uniform float horizontal_scan_lines_amount : hint_range(0.0, 180.0, 0.1) = 180.0;
uniform float horizontal_scan_lines_opacity : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool show_vertical_scan_lines = false;
uniform float vertical_scan_lines_amount : hint_range(0.0, 320.0, 0.1) = 320.0;
uniform float vertical_scan_lines_opacity : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float boost : hint_range(1.0, 2.0, 0.01) = 1.2;
uniform float aberration_amount : hint_range(0.0, 10.0, 0.01) = 0.0;

vec2 uv_curve(vec2 uv) {
	if (show_curvature) {
		uv = uv * 2.0 - 1.0;
		vec2 offset = abs(uv.yx) / vec2(curvature_x_amount, curvature_y_amount);
		uv = uv + uv * offset * offset;
		uv = uv * 0.5 + 0.5;
	}

	return uv;
}
vec3 tex2D( sampler2D _tex, vec2 _p ){
	vec3 col = texture( _tex, _p ).xyz;
	if ( 0.5 < abs( _p.x - 0.5 ) ) {
		col = vec3( 0.1 );
	}
	return col;
}

float hash( vec2 _v ){
	return fract( sin( dot( _v, vec2( 89.44, 19.36 ) ) ) * 22189.22 );
}

float iHash( vec2 _v, vec2 _r ){
	float h00 = hash( vec2( floor( _v * _r + vec2( 0.0, 0.0 ) ) / _r ) );
	float h10 = hash( vec2( floor( _v * _r + vec2( 1.0, 0.0 ) ) / _r ) );
	float h01 = hash( vec2( floor( _v * _r + vec2( 0.0, 1.0 ) ) / _r ) );
	float h11 = hash( vec2( floor( _v * _r + vec2( 1.0, 1.0 ) ) / _r ) );
	vec2 ip = vec2( smoothstep( vec2( 0.0, 0.0 ), vec2( 1.0, 1.0 ), mod( _v*_r, 1. ) ) );
	return ( h00 * ( 1. - ip.x ) + h10 * ip.x ) * ( 1. - ip.y ) + ( h01 * ( 1. - ip.x ) + h11 * ip.x ) * ip.y;
}

float noise( vec2 _v ){
	float sum = 0.;
	for( float i=1.0; i<9.0; i++ ){
	sum += iHash( _v + vec2( i ), vec2( 2. * pow( 2., float( i ) ) ) ) / pow( 2., float( i ) );
	}
	return sum;
}


void fragment() {
	vec2 uv = uv_curve(UV);
	vec2 uvn = uv;
	vec2 screen_uv = uv_curve(SCREEN_UV);
	vec3 color = texture(SCREEN_TEXTURE, screen_uv).rgb;
	if (aberration_amount > 0.0) {
		float adjusted_amount = aberration_amount / screen_size.x;
		color.r = texture(SCREEN_TEXTURE, vec2(screen_uv.x + adjusted_amount, screen_uv.y)).r;
		color.g = texture(SCREEN_TEXTURE, screen_uv).g;
		color.b = texture(SCREEN_TEXTURE, vec2(screen_uv.x - adjusted_amount, screen_uv.y)).b;
	}
	// tape wave
	uvn.x += ( noise( vec2( uvn.y, TIME ) ) - 0.5 )* 0.001;
	uvn.x += ( noise( vec2( uvn.y * 100.0, TIME * 10.0 ) ) - 0.5 ) * tape_wave_amount;
	
	// tape crease
	float tcPhase = clamp( ( sin( uvn.y * 8.0 - TIME * PI * 1.2 ) - 0.92 ) * noise( vec2( TIME ) ), 0.0, 0.01 ) * tape_crease_amount;
	float tcNoise = max( noise( vec2( uvn.y * 100.0, TIME * 10.0 ) ) - 0.5, 0.0 );
	uvn.x = uvn.x - tcNoise * tcPhase;
	
	// switching noise
	float snPhase = smoothstep( 0.03, 0.0, uvn.y );
	uvn.y += snPhase * 0.125;
	uvn.x += snPhase * ( ( noise( vec2( uv.y * 100.0, TIME * 10.0 ) ) - 0.5 ) * 0.0 );
	
	color = tex2D( SCREEN_TEXTURE, uvn );
	color *= 1.0 - tcPhase;
	color = mix(
		color,
		color.yzx,
		snPhase
	);
/*
	// bloom
	for( float x = -1.0; x < 2.5; x += 2.0 ){
		color.xyz += vec3(
		tex2D( SCREEN_TEXTURE, uvn + vec2( x - 0.0, 0.0 ) * 0.007 ).x,
		tex2D( SCREEN_TEXTURE, uvn + vec2( x - color_displacement, 0.0 ) * 0.007 ).y,
		tex2D( SCREEN_TEXTURE, uvn + vec2( x - color_displacement * 2.0, 0.0 ) * 0.007 ).z
		) * 0.01;
	}
*/
	color *= 0.5;
	
	// ac beat
	color *= 1.0 + clamp( noise( vec2( 0.0, uv.y + TIME * lines_velocity ) ) * 0.16 - 0.25, 0.0, 0.1 );
	
	
	if (show_horizontal_scan_lines) {
		float s = sin(screen_uv.y * horizontal_scan_lines_amount * PI * 2.0);
		s = (s * 0.5 + 0.5) * 0.9 + 0.1;
		vec4 scan_line = vec4(vec3(pow(s, horizontal_scan_lines_opacity)), 1.0);
		color *= scan_line.rgb;
	}
	if (show_vertical_scan_lines) {
		float s = sin(screen_uv.x * vertical_scan_lines_amount * PI * 2.0);
		s = (s * 0.5 + 0.5) * 0.9 + 0.1;
		vec4 scan_line = vec4(vec3(pow(s, vertical_scan_lines_opacity)), 1.0);
		color *= scan_line.rgb;
	}
	if (show_horizontal_scan_lines || show_vertical_scan_lines) {
		color *= boost;
	}
	// Fill the blank space of the corners, left by the curvature, with black.
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = corner_color.rgb;
	}
	if (show_vignette) {
		float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
		vignette = clamp(pow((screen_size.x / 4.0) * vignette, vignette_opacity), 0.0, 1.0);
		color *= vignette;
	}
	COLOR = vec4( color, 1.0 );
}
