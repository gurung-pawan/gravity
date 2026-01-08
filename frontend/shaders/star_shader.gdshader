shader_type canvas_item;
render_mode blend_add;

uniform vec4 glow_color : source_color = vec4(1.0, 0.6, 0.2, 1.0);
uniform float glow_intensity = 5;

void fragment() {
    vec4 albedo = texture(TEXTURE, UV) * COLOR;

    albedo.rgb += glow_color.rgb * glow_intensity;

    COLOR = albedo;
}