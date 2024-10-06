extends Node2D

var basic_combat_scene = preload("res://scenes/combat.tscn")

var basic_bug = preload("res://scenes/bug.tscn")
var map = preload("res://scenes/map.tscn")
var preload_attack = preload("res://scripts/attack.gd")
var map_node = preload("res://scripts/map_node.gd")

var CURRENT_PARTY = []

var MAP

# Called when the node enters the scene tree for the first time.
func _ready():
	
	generate_map_tree(5)
	# walkMap(MAP)

	var map_object = map.instantiate()
	get_node("/root/Index").add_child(map_object)
	
	
	# var test_ant = basic_bug.instantiate()
	# test_ant.speed = 1
	# test_ant.health = 5
	# test_ant.player_controlled = true
	# var attack = preload_attack.new()
	# attack.attack_name = "Super Pinch"
	
	# var attack2 = preload_attack.new()
	# attack2.attack_name = "Super Duper Pinch"
	# test_ant.attacks_list = [attack, attack2]
	# CURRENT_PARTY.append(test_ant)
	# #print("Asdsdsds")
	# var current_combat = basic_combat_scene.instantiate()
	# var scene_root = get_node("/root/Index/")
	# scene_root.add_child(current_combat)
	
	
	# current_combat.spawnPlayerTeam(CURRENT_PARTY)
	
	# var evil_ant = basic_bug.instantiate()
	# var evil_ant2 = basic_bug.instantiate()
	# var evil_ant3 = basic_bug.instantiate()
	# var evil_ant4 = basic_bug.instantiate()
	# evil_ant.speed = 2
	# evil_ant2.speed = 3
	# evil_ant3.speed = 3
	# evil_ant4.speed = 3
	# current_combat.spawnEnemyTeam([evil_ant, evil_ant2, evil_ant3, evil_ant4])
	# current_combat.initCombatQueue()
	# #print("B")
	# pass # Replace with function body.

func walkMap(node):
	print(node.node_type)
	print(node.children)
	for c in node.children:
		print(c.node_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func generate_map_tree(floors):
	
	var max_tree_width = 5;
	var min_tree_width = 2;

	MAP = map_node.new()
	MAP.name = "MapNode_0"
	
	var previous_floor = [MAP]
	var node_counter = 1;
	# save room for spawn+boss floors
	for floor_number in range(floors - 2):
		var next_floor_width = randi_range(min_tree_width, max_tree_width)

		var next_floor = []
		for j in range(next_floor_width):
			var new_node = map_node.new()
			new_node.randomize_node_type()
			new_node.name = "MapNode_" + str(node_counter)
			next_floor.append(new_node)
			node_counter += 1
		
		for current_index in previous_floor.size():
			var next_width = next_floor.size()

			var children = []
			if (randf() > .5) && current_index > 0 && current_index - 1 < next_width:
				# 50% chance this floor will connect w/ the floor indexed before it from previous row
				children.append(next_floor[current_index - 1])
			
			children.append(next_floor[min(current_index, next_width - 1)] )
			
			if randf() > .5 && current_index > 0 && current_index + 1 < next_width:
				# 50% chance this floor will connect w/ the floor indexed before it from previous row
				children.append(next_floor[current_index + 1])
				
			previous_floor[current_index].set_children(children)

		for index in next_floor.size():
			if !next_floor[index].parent:
				next_floor[index].set_parent(previous_floor[clamp(index, 0, previous_floor.size() - 1)])
		
		previous_floor = next_floor

	var BOSS_FLOOR = map_node.new();
	BOSS_FLOOR.set_node_type("boss")
	for node in previous_floor:
		node.set_children([BOSS_FLOOR])


	
