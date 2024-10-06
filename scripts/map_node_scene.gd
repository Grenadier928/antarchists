extends TextureButton

var map_controller = null
var map_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_node(node):
	map_node = node
	node.map_button = self
	texture_normal = load(node.NODE_ICONS[node.node_type])

func get_sprite_size():
	return texture_normal.get_size() * get_scale();

func _on_pressed() -> void:
	map_controller.testFunc()
