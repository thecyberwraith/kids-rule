shader_type spatial;
uniform float flash;
uniform vec3 flash_color: source_color;
uniform sampler2D albedo_tex: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 old_color = texture(albedo_tex, UV);
	ALBEDO.rgb = mix(old_color.rgb, flash_color, flash);
	ALPHA = old_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
