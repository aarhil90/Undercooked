extends Control

@export
var bus_name: String

var bus_index: int
@onready var slider = $HSlider  # Adjust the node path to match your HSlider's name in the scene

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	if slider:
		slider.value = linear_to_db(AudioServer.get_bus_volume_db(bus_index))
		slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)

func _on_back_pressed() -> void:
	print("back pressed")
	get_tree().change_scene_to_file("res://menu.tscn")
