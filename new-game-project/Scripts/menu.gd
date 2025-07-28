extends Control

func _on_play_pressed() -> void:
	var error = get_tree().change_scene_to_file("res://game.tscn")
	if error != OK:
		print("Failed to change scene: ", error)

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	var error = get_tree().change_scene_to_file("res://tutorial.tscn")
	if error != OK:
		print("Failed to change scene: ", error)

func _on_exit_pressed() -> void:
	get_tree().quit() # Use quit() instead of exit()
