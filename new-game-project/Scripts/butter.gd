extends AnimatableBody2D

var speed = 100
var direction = Vector2.RIGHT
var distance = 200
var start_pos = Vector2.ZERO
var player_on_platform = null

func _ready():
	start_pos = global_position  # Use global coordinates
	sync_to_physics = false  # Disable physics sync for direct position control
	add_to_group("platforms")
	print("Start position (local):", position, "Global:", global_position)

func _physics_process(delta):
	# Move platform
	global_position += direction * speed * delta
	if abs(global_position.x - start_pos.x) > distance:
		direction *= -1
		print("Reversing at position:", global_position)

	# Check for player collision
	var collision = move_and_collide(Vector2.ZERO, true, true)
	if collision and collision.get_collider().is_in_group("player"):
		if not player_on_platform:
			print("Player collided with:", collision.get_collider().name)
			player_on_platform = collision.get_collider()
			var player_global_pos = player_on_platform.global_position
			player_on_platform.get_parent().remove_child(player_on_platform)
			add_child(player_on_platform)
			player_on_platform.global_position = player_global_pos
	elif player_on_platform:
		var player_global_pos = player_on_platform.global_position
		remove_child(player_on_platform)
		get_tree().current_scene.add_child(player_on_platform)
		player_on_platform.global_position = player_global_pos
		player_on_platform = null
