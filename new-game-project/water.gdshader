shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float distortion_strength : hint_range(0.001, 0.2) = 0.05;
uniform float wave_speed : hint_range(0.5, 5.0) = 2.0;
uniform float wave_frequency : hint_range(1.0, 20.0) = 8.0;
uniform vec4 water_tint : source_color = vec4(0.5, 0.8, 1.0, 0.3);

void fragment() {
    float time = TIME * wave_speed;
    
    // Create wave distortion
    float wave1 = sin(UV.y * wave_frequency + time) * distortion_strength;
    float wave2 = sin(UV.y * wave_frequency * 1.5 + time * 1.3) * distortion_strength * 0.5;
    
    // Distort the screen coordinates
    vec2 distorted_screen_uv = SCREEN_UV;
    distorted_screen_uv.x += wave1 + wave2;
    
    // Sample what's behind this pixel
    vec3 background = texture(screen_texture, distorted_screen_uv).rgb;
    
    // Apply water tint
    COLOR.rgb = mix(background, water_tint.rgb, water_tint.a);
    COLOR.a = 1.0;
}