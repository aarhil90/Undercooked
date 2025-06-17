extends CharacterBody2D

@export var accelcecrationValue = 0.01

@export var slideValue = 0.01
@export var fullStopValue = 15
@onready var floor_ray_cast_2d: RayCast2D = $floorRayCast2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

func _movement_on_ice(direction):
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, accelcecrationValue)
	else:
		velocity.x = lerp(velocity.x, 0.0, slideValue)
		
		if velocity.x < fullStopValue and velocity.x >-fullStopValue:
			velocity.x = 0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if _is_on_ice():
		_movement_on_ice(direction)
	else:
		_normal_movement(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _movement_on_ice(direction):
	pass

func _normal_movement(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _is_on_ice():
	var collider = floor_ray_cast_2d.get_collider()
	
	if not collider: return false
	
	return collider.name == "iceBlocks"
