extends Node2D

@export var pickups : Array[PackedScene]
@onready var spawn_points = get_tree().get_nodes_in_group("SpawnPoint")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawn_food()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_food():
	for spawn_point in spawn_points:
		var new_food = spawn_point.spawn_item.instantiate()
		add_child(new_food)
		new_food.global_position  = spawn_point.global_position
	
func respawn():
	var existing_food = get_tree().get_nodes_in_group("Food")
	for food in existing_food:
		food.queue_free()
	spawn_food()
