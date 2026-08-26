shader_type canvas_item;

uniform float movement_speed : hint_range(0.0, 2.0) = 0.35;
uniform float distortion : hint_range(0.0, 0.2) = 0.035;
uniform float glow_strength : hint_range(0.0, 3.0) = 1.2;
uniform float shine_strength : hint_range(0.0, 3.0) = 1.5;

// RIPPLE SETTINGS
uniform float ripple_strength : hint_range(0.0, 1.0) = 0.0;
uniform float ripple_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 ripple_position = vec2(0.5, 0.5);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Keep the original shape/transparency
	float alpha = tex.a;

	vec2 uv = UV;

	// Slowly move the surface around
	uv.x += sin(uv.y * 10.0 + TIME * movement_speed) * distortion;
	uv.y += cos(uv.x * 12.0 + TIME * movement_speed) * distortion;


	// =========================================
	// RIPPLE
	// =========================================

	float ripple_distance = distance(uv, ripple_position);

	// Expanding ring
	float ripple_radius = ripple_progress * 0.75;

	float ripple = 1.0 - smoothstep(
		0.0,
		0.08,
		abs(ripple_distance - ripple_radius)
	);

	// Make the ripple fade as it expands
	ripple *= (1.0 - ripple_progress);

	// Distort UV around the ripple
	vec2 ripple_direction = normalize(uv - ripple_position);

	uv += ripple_direction * ripple * ripple_strength * 0.08;


	// =========================================
	// DISTANCE FROM CENTRE
	// =========================================

	float dist = distance(uv, vec2(0.5));

	float rim = smoothstep(0.18, 0.5, dist);


	// =========================================
	// RED LIQUID
	// =========================================

	vec3 dark_red = vec3(0.12, 0.005, 0.015);
	vec3 red = vec3(0.65, 0.015, 0.04);
	vec3 bright_red = vec3(1.0, 0.08, 0.12);

	vec3 bubble_color = mix(red, dark_red, rim);


	// =========================================
	// INTERNAL LIQUID MOVEMENT
	// =========================================

	float liquid_wave =
		sin(uv.x * 14.0 + TIME * movement_speed * 2.0) *
		sin(uv.y * 10.0 - TIME * movement_speed);

	liquid_wave = liquid_wave * 0.5 + 0.5;

	bubble_color += bright_red * liquid_wave * 0.18;


	// =========================================
	// GLOWING OUTER RIM
	// =========================================

	bubble_color += bright_red * rim * glow_strength * 0.35;


	// =========================================
	// RIPPLE GLOW
	// =========================================

	bubble_color += vec3(1.0, 0.08, 0.15) * ripple * ripple_strength;


	// =========================================
	// MOVING GLOSSY REFLECTION
	// =========================================

	vec2 shine_pos = vec2(
		0.30 + sin(TIME * movement_speed) * 0.12,
		0.25 + cos(TIME * movement_speed * 0.8) * 0.08
	);

	float shine_distance = distance(uv, shine_pos);

	float shine = 1.0 - smoothstep(
		0.0,
		0.16,
		shine_distance
	);

	bubble_color += vec3(1.0, 0.55, 0.6) * shine * shine_strength;


	// =========================================
	// TRANSPARENCY
	// =========================================

	float bubble_alpha =
		alpha *
		(0.15 + rim * 0.5 + shine * 0.3);

	// Ripple makes the edge temporarily brighter
	bubble_alpha += ripple * ripple_strength * 0.25;

	COLOR = vec4(bubble_color, bubble_alpha);
}