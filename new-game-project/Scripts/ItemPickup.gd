
extends Area2D  # or RigidBody2D, CharacterBody2D, etc.

signal item_picked_up(item_name: String)

@export var item_name: String = "Magic Shroom"
@export var pickup_sound: AudioStream  # Optional pickup sound

func _ready():
	# Add to the item_pickups group so DistortionManager can find it
	add_to_group("item_pickups")
	
	# Connect collision signals
	if has_signal("body_entered"):
		body_entered.connect(_on_body_entered)
	elif has_signal("area_entered"):
		area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "Player":
		pickup_item()

func _on_area_entered(area):
	if area.is_in_group("player") or area.name == "Player":
		pickup_item()

func pickup_item():
	print("Picked up: ", item_name)
	
	# Play sound if available
	"if pickup_sound:
		AudioManager.play_sound(pickup_sound)  # Adjust to your audio system"
	
	# Emit signal
	item_picked_up.emit(item_name)
	
	# Remove the item
	queue_free()
