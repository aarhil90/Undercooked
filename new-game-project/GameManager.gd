extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
var player_start_position = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_start_position = player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position():
	player.global_position = player_start_position
	
