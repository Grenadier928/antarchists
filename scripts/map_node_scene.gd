extends TextureButton

var map_controller = null
var map_node

var anim_state = "grow"
var grow_big_size = 1.2
var grow_small_size = 0.9
var grow_speed = 0.01

var visited_added = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	#print("AASD")
	if map_node.travelable:
		#print("anmate")
		#scale.y = 1000
		#scale.x = 1000
		#return
		if anim_state == "grow":
			if scale.x <= grow_big_size:
				#print("Big")
				scale.y += grow_speed
				scale.x += grow_speed
			else:
				anim_state = "shrink"
		if anim_state == "shrink":
			if scale.x >= grow_small_size:
				#print("Small")
				scale.y -= grow_speed
				scale.x -= grow_speed
			else:
				anim_state = "grow"

	if !visited_added and map_node.visited:
		var marker = Sprite2D.new()
		marker.texture = load("res://textures/visited_map_node.png")	

		marker.position = get_sprite_size()/2
		add_child(marker)
		visited_added = true
	pass # Replace with function body.



func add_node(node):
	map_node = node
	node.map_button = self
	texture_normal = load(node.NODE_ICONS[node.node_type])

func get_sprite_size():
	return texture_normal.get_size() * get_scale();

func _on_pressed() -> void:
	map_controller.testFunc(map_node)
