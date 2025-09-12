extends Area2D

@export var is_ice: bool = false

func _ready():
	print("Ice block ready! Is ice: ", is_ice)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("SOMETHING ENTERED THE ICE BLOCK!")
	print("Body name: ", body.name)
	print("This ice block is_ice: ", is_ice)
	
	# Check for player
	if body.name == "Player" or body.is_in_group("Player") or body.name == "layer0":
		print("Player detected! Changing all floor tiles...")
		
		# Find and modify all floor tiles
		var floor_tiles = get_tree().get_nodes_in_group("FLOOR")
		for tile in floor_tiles:
			tile.is_ice = is_ice
			print("Set floor tile ice to: ", is_ice)
		
		print("Changed ", floor_tiles.size(), " floor tiles")
