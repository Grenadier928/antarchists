extends Node2D


var camera: Camera2D
var SCROLL_SPEED = 50

var map_node_button = preload("res://scenes/map_node_scene.tscn")

var map_controller = null
var map_object
var map_array

var INDEX_CONTROLLER = null
#pixel distance between the floor rows
var DISTANCE_BETWEEN_FLOORS = 300
var MAX_TREE_WIDTH

# how far in any direction a node may be randomly skewed
var MAX_VARIANCE = 75

var LINE_COLOR = Color(0, 1, 0)

var LINES = []

func _ready() -> void:
	
	MAX_TREE_WIDTH = get_viewport().size.x 
	camera = get_node("Camera2D")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			self.position.y += SCROLL_SPEED
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			self.position.y -= SCROLL_SPEED

func draw_map(map):
	map_object = map
	draw_map_nodes()
	recursive_map_connect(map_object[0][0])
	for c_node in INDEX_CONTROLLER.CURRENT_MAP_NODE.children:
		c_node.travelable = true
	self.queue_redraw()
	

func _draw() -> void:
	for line in LINES:
		draw_line(line[0], line[1], LINE_COLOR, 5)

func draw_map_nodes():
	for row_number in range(map_object.size()):
		var row_height = -DISTANCE_BETWEEN_FLOORS * row_number

		var x_delta = 0
		var x_position = 0
		if (map_object[row_number].size() > 1):
			x_delta = MAX_TREE_WIDTH / (map_object[row_number].size() - 1)
			x_position = -MAX_TREE_WIDTH / 2
		

		for row_node in map_object[row_number]:
			var map_node = map_node_button.instantiate()
			map_node.add_node(row_node)
			map_node.map_controller = self


			var random_offset = Vector2(randf_range(-MAX_VARIANCE, MAX_VARIANCE), randf_range(-MAX_VARIANCE, MAX_VARIANCE))
			map_node.position = Vector2(x_position, row_height) + random_offset

			self.add_child(map_node)

			x_position += x_delta

func recursive_map_connect(node):
	for child in node.children:
		recursive_map_connect(child)
		LINES.append([node.map_button.position + (node.map_button.get_sprite_size() / 2)
			, child.map_button.position + (child.map_button.get_sprite_size() / 2)])


func testFunc(map_node):
	#print("Map.gd TEST")
	if not map_node.travelable:
		return
	#print(map_node.node_type)
	INDEX_CONTROLLER.CURRENT_MAP_NODE = map_node
	if map_node.node_type == "combat":
		INDEX_CONTROLLER.loadCombatEncounter(null)
	elif map_node.node_type == "event":
		INDEX_CONTROLLER.loadEvent(null)
