extends ColorRect

@export var effect_duration: float = 3.0
@export var distortion_strength: float = 0.08

var shader_material: ShaderMaterial

func _ready():
	print("DistortionController ready")
	
	# Force the ColorRect to be visible and cover the full screen
	visible = true
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modulate = Color.WHITE  # Make sure it's not tinted
	
	# Get the shader material
	shader_material = material as ShaderMaterial
	
	if shader_material:
		print("Shader material found")
		# Start with no distortion
		shader_material.set_shader_parameter("wave_strength", 0.0)
		# Test: set show_distortion_only to see if shader works
		shader_material.set_shader_parameter("show_distortion_only", false)
	else:
		print("ERROR: No shader material found! Make sure to apply the distortion shader to this ColorRect")
		# Make it red so you can see it's there but no shader
		color = Color.RED

func activate_distortion():
	print("=== DISTORTION ACTIVATED ===")
	
	# Make sure it's visible and covering screen
	visible = true
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	if shader_material:
		print("Setting strong distortion effect")
		# Set very strong values so it's obvious
		shader_material.set_shader_parameter("wave_strength", 0.15)
		shader_material.set_shader_parameter("wave_frequency", 8.0)
		shader_material.set_shader_parameter("animation_speed", 2.0)
		shader_material.set_shader_parameter("show_distortion_only", true)  # Debug mode
		
		print("Distortion should be visible now!")
	else:
		print("No shader - showing red overlay instead")
		color = Color.RED
		modulate.a = 0.5
	
	# Turn off after duration
	await get_tree().create_timer(effect_duration).timeout
	
	print("Turning off distortion")
	if shader_material:
		shader_material.set_shader_parameter("wave_strength", 0.0)
		shader_material.set_shader_parameter("show_distortion_only", false)
	else:
		color = Color.WHITE
		modulate.a = 1.0

func set_wave_strength(value: float):
	print("Setting wave strength to: ", value)  # DEBUG
	if shader_material:
		shader_material.set_shader_parameter("wave_strength", value)
		# Also try setting other parameters to make it more visible
		shader_material.set_shader_parameter("wave_frequency", 8.0)
		shader_material.set_shader_parameter("animation_speed", 2.0)
	else:
		print("ERROR: No shader material found!")

# For testing - press Home to activate manually
func _input(event):
	if event.is_action_pressed("ui_home"):
		print("Manual test activation")
		activate_distortion()
