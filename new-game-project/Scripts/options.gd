extends Control

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_back_pressed() -> void:
	print("back pressed")
	get_tree().change_scene_to_file("res://menu.tscn")

var is_muted: bool = false
var original_volume: float = 0.0  # Store the original volume

func _on_check_button_toggled(toggled_on: bool) -> void:
	print("Mute button toggled: ", toggled_on)
	is_muted = toggled_on
	
	var master_bus = AudioServer.get_bus_index("Master")
	
	if is_muted:
		# Store current volume before muting
		original_volume = AudioServer.get_bus_volume_db(master_bus)
		AudioServer.set_bus_volume_db(master_bus, -80)
		print("Audio muted - stored volume: ", original_volume)
	else:
		# Restore original volume
		AudioServer.set_bus_volume_db(master_bus, original_volume)
		print("Audio unmuted - restored volume: ", original_volume)
