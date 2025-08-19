shader_type canvas_item;

// Exported parameters for customization
uniform vec4 top_color : source_color = vec4(1.0, 1.0, 1.0, 0.0); // Default: transparent white
uniform vec4 bottom_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Default: opaque black
uniform float gradient_power : hint_range(0.1, 5.0) = 1.0; // Controls gradient curve

void fragment() {
    // Get the UV coordinate (0.0 at top, 1.0 at bottom)
    float gradient_factor = UV.y;
    
    // Apply power curve to the gradient for more control
    gradient_factor = pow(gradient_factor, gradient_power);
    
    // Mix between top and bottom colors based on vertical position
    COLOR = mix(top_color, bottom_color, gradient_factor);
}