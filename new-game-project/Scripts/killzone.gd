extends Area2D

@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D



func _on_body_entered(body):
	if body.name == "Player":
		print("ouch")
		#await get_tree().create_timer(1)
		get_tree().reload_current_scene()


	
