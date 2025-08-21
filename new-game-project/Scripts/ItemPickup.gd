extends Area2D

# Drag the ColorRect with DistortionController script here in the inspector
@export var distortion_controller: ColorRect

func _ready():
	# Connect to player entering the area
	body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	# Check if it's the player
	if body.name == "Player":
		pickup_item()

func pickup_item():
	print("Item picked up!")
	
	# Activate the distortion effect
	if distortion_controller and distortion_controller.has_method("activate_distortion"):
		distortion_controller.activate_distortion()
	
	# Remove this item
	queue_free()
