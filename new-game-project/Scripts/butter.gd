extends AnimatableBody2D

var speed = 100
var direction = Vector2.RIGHT
var distance = 200
var start_pos = Vector2.ZERO
var player_on_platform = null

func _ready():
	start_pos = position
	add_to_group("platforms")  # Identify as platform

func _physics_process(delta):
	# Move platform
	position += direction * speed * delta
	if position.distance_to(start_pos) > distance:
		direction *= -1  # Reverse direction

	# Check for player collision
	var collision = move_and_collide(Vector2.ZERO, true, true)  # Test-only collision
	if collision and collision.get_collider().is_in_group("player"):
		if not player_on_platform:
			print("Player collided with:", collision.get_collider().name)  # Debug
			player_on_platform = collision.get_collider()
			player_on_platform.get_parent().remove_child(player_on_platform)
			add_child(player_on_platform)  # Player moves with platform
	elif player_on_platform:
		# Player left platform
		remove_child(player_on_platform)
		get_tree().current_scene.add_child(player_on_platform)
		player_on_platform = null
