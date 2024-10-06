extends Node2D

var map_node_button = preload("res://scenes/map_node_scene.tscn")

var map_controller = null

func _ready() -> void:
	var temp = map_node_button.instantiate()

	temp.map_controller = self
	self.add_child(temp)
	print(temp.map_controller)
	print("MAP READY")


func testFunc():
	print("Map.gd TEST")
