extends Control

func _on_play_pressed() -> void:
	print ("play pressed")
	get_tree().change_scene_to_file("res://game.tscn")


func _on_tutorial_pressed() -> void:
	print ("tutorial pressed")
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_options_pressed() -> void:
	print ("options pressed")
	get_tree().change_scene_to_file("res://options.tscn")


func _on_exit_pressed() -> void:
	print ("exit pressed")
	get_tree().quit()

func _on_back_pressed() -> void:
	print ("back pressed")
	get_tree().change_scene_to_file("res://menu.tscn")
