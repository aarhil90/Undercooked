extends Button

func _on_BackButton_pressed() -> void:
	print ("BB pressed")
	


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
