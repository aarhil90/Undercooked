shader_type canvas_item;

// Screen texture for background sampling
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// Exported parameters for customization
uniform float wave_strength : hint_range(0.0, 0.2) = 0.05; // How strong the distortion is
uniform float wave_frequency : hint_range(1.0, 20.0) = 5.0; // How many waves
uniform float swirl_strength : hint_range(0.0, 2.0) = 1.0; // How much swirling
uniform float animation_speed : hint_range(0.0, 5.0) = 1.0; // Speed of animation
uniform vec2 swirl_center = vec2(0.5, 0.5); // Center of swirl effect
uniform bool show_distortion_only = false; // Debug mode
uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 0.5); // Base color when no background

void fragment() {
    vec2 uv = UV;
    
    // Calculate distance and angle from swirl center
    vec2 center_offset = uv - swirl_center;
    float distance_from_center = length(center_offset);
    float angle = atan(center_offset.y, center_offset.x);
    
    // Create time-based animation
    float time = TIME * animation_speed;
    
    // Generate swirly wave distortion
    vec2 distortion = vec2(0.0);
    
    // Circular wave pattern
    float circular_wave = sin(distance_from_center * wave_frequency + time) * wave_strength;
    
    // Swirl effect - rotate based on distance from center
    float swirl_amount = swirl_strength * (1.0 - distance_from_center) * sin(time * 0.5);
    float swirl_angle = angle + swirl_amount;
    
    // Combine wave and swirl effects
    distortion.x = cos(swirl_angle) * circular_wave + sin(uv.y * wave_frequency + time) * wave_strength * 0.5;
    distortion.y = sin(swirl_angle) * circular_wave + cos(uv.x * wave_frequency + time) * wave_strength * 0.5;
    
    // Add some turbulence for more complex movement
    float turbulence_x = sin(uv.x * wave_frequency * 2.0 + time * 1.3) * cos(uv.y * wave_frequency * 1.5 + time * 0.7);
    float turbulence_y = cos(uv.x * wave_frequency * 1.5 + time * 0.9) * sin(uv.y * wave_frequency * 2.0 + time * 1.1);
    
    distortion += vec2(turbulence_x, turbulence_y) * wave_strength * 0.3;
    
    // Apply distortion to UV coordinates
    vec2 distorted_uv = uv + distortion;
    
    if (show_distortion_only) {
        // Debug mode - visualize the distortion as colors
        COLOR = vec4(distortion * 10.0 + 0.5, 0.0, 1.0);
    } else {
        // Sample the screen texture with distortion
        vec4 screen_color = texture(screen_texture, SCREEN_UV + distortion);
        COLOR = screen_color;
    }
}