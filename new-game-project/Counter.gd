extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Get the OrderDisplay (parent Control node)
		var order_display = get_parent()
		if order_display and order_display.has_method("check_order"):
			if order_display.check_order(body.items_collected):
				print("Order completed successfully!")
			else:
				print("Order doesn't match current requirements")
