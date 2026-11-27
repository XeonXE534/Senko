shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.2, 0.8, 1.0, 1.0);
uniform float strength : hint_range(0.0, 8.0) = 3.0;
uniform float core_width : hint_range(0.0, 1.0) = 0.15;  // hot center
uniform float falloff : hint_range(0.5, 8.0) = 3.0;      // higher = tighter fade

void fragment() {
    float d = abs(UV.y - 0.5) * 2.0;        // 0 center, 1 edge
    float core = 1.0 - smoothstep(0.0, core_width, d);
    float halo = pow(1.0 - d, falloff);     // soft fade to nothing at the edges
    float a = clamp(core + halo, 0.0, 1.0);
    COLOR = vec4(glow_color.rgb * strength, a);
}