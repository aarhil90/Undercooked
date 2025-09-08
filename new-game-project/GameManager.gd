extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
var player_start_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find player when ready
	find_player()

func find_player():
	player = get_tree().get_first_node_in_group("Player")
	if player:
		player_start_position = player.global_position
		print("Player found and start position set: ", player_start_position)
	else:
		print("Player not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position():
	# Make sure we have a valid player reference
	if not player or not is_instance_valid(player):
		find_player()
	
	if player and is_instance_valid(player):
		player.global_position = player_start_position
		player.clear_inventory()
		respawn_items()
	else:
		print("Cannot reset - player not found!")

func respawn_items():
	var spawn_points_manager = get_tree().get_first_node_in_group("SpawnPointsManager")
	if spawn_points_manager and spawn_points_manager.has_method("respawn"):
		spawn_points_manager.respawn()
		print("Items respawned")
	else:
		print("Could not find SpawnPoints manager or respawn method")
