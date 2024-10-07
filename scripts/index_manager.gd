extends Node2D

var basic_combat_scene = preload("res://scenes/combat.tscn")
var basic_event_scene = preload("res://scenes/random_event.tscn")

var basic_bug = preload("res://scenes/bug.tscn")
var preload_attack = preload("res://scripts/attack.gd")
var map = preload("res://scenes/map.tscn")
var map_node = preload("res://scripts/map_node.gd")

var MAP
var MAP_HEIGHT = 10

var CURRENT_PARTY = []
var CURRENT_ITEMS = []
var CURRENT_HEIGHT = 1
var volume: float = 1.0
var sfx: bool = true
var bg: bool = true
var CURRENT_MAP_NODE = null


var master_bug_dict = null
var master_attack_dict = null
var master_event_dict = null
var master_combat_encounter_dict = null

var current_combat = null
var current_event = null

func createAttackFromId(id):
	var dict_entry = null
	for i in range (master_attack_dict.size()):
		#print(master_bug_dict[i])
		if master_attack_dict[i].id == id:
			dict_entry = master_attack_dict[i]
			break
	print(dict_entry)
	var temp_attack = preload_attack.new()
	temp_attack.base_damage = dict_entry.base_damage
	#temp_attack.attack_damage = dict_entry.attack_damage
	temp_attack.id = dict_entry.id
	temp_attack.sound_effect = dict_entry.sound_effect
	temp_attack.attack_name = dict_entry.attack_name
	temp_attack.description = dict_entry.description
	return temp_attack


func createBugFromId(id, player_controlled):
	var dict_entry = null
	for i in range (master_bug_dict.size()):
		#print(master_bug_dict[i])
		if master_bug_dict[i].id == int(id):
			dict_entry = master_bug_dict[i]
			break
	var temp_bug = basic_bug.instantiate()
	
	for i in range (dict_entry.attacks_list.size()):
		temp_bug.attacks_list.append(createAttackFromId(dict_entry.attacks_list[i]))
	temp_bug.health = dict_entry.health
	temp_bug.speed = dict_entry.speed
	temp_bug.evasion = dict_entry.evasion
	temp_bug.strength = dict_entry.strength
	temp_bug.quips = dict_entry.quips
	temp_bug.sprite_path = dict_entry.sprite_path
	temp_bug.player_controlled = player_controlled
	#temp_bug.init()
	return temp_bug

func loadJsonManifest(path):
	var raw_file = FileAccess.open(path, FileAccess.READ)
	var raw_json = raw_file.get_as_text()
	raw_file.close()
	var json_reader = JSON.new()
	var temp_json = json_reader.parse(raw_json)
	var data_received = json_reader.data#.attacks[0]
	return data_received


func loadEvent(event_id):
	current_event = basic_event_scene.instantiate()
	var scene_root_n = get_node("/root/Index/")
	scene_root_n.add_child(current_event)
	
	var event_num = event_id
	
	if event_num == null:
		var rng = RandomNumberGenerator.new()
		event_num = rng.randi_range(0, master_event_dict.size() - 1)
	var p_event = master_event_dict[event_num]
	
	current_event.init(p_event, self)
	return current_event
	
	
func loadCombatEncounter(combat_encounter_id):
	
	if combat_encounter_id == null:
		var rng = RandomNumberGenerator.new()
		combat_encounter_id = rng.randi_range(0, master_combat_encounter_dict.size() - 1)
	var dict_entry = null
	print("Encounter id: " + str(combat_encounter_id))
	for i in range (master_combat_encounter_dict.size()):
		#print(master_bug_dict[i])
		if master_combat_encounter_dict[i].id == combat_encounter_id:
			dict_entry = master_combat_encounter_dict[i]
			break
	current_combat = basic_combat_scene.instantiate()
	current_combat.index_manager = self
	var scene_root = get_node("/root/Index/")
	scene_root.add_child(current_combat)
	if CURRENT_PARTY.size() == 0:
		OS.alert("Attempted to start a combat, but player team size is 0", "ALERT")
	
	print("CURRENT PARTY:")
	print(CURRENT_PARTY)
	current_combat.spawnPlayerTeam(CURRENT_PARTY)
	var enemy_team = []
	
	for i in range (dict_entry.enemy_list.size()):
		enemy_team.append(createBugFromId(dict_entry.enemy_list[i], false))
	current_combat.spawnEnemyTeam(enemy_team)
	print(enemy_team)
	print(CURRENT_PARTY)
	#for i in range (dict_entry.attacks_list.size()):
	#current_combat.spawnEnemyTeam([evil_ant, evil_ant2, evil_ant3])
	current_combat.initCombatQueue()
#func testCombatEncounter():

func generate_map_tree(floors):
	
	var max_tree_width = 5;
	var min_tree_width = 2;

	var root_node = map_node.new()
	root_node.name = "MapNode_0"

	var map_object = []
	
	var previous_floor = [root_node]
	var node_counter = 1;
	# save room for spawn+boss floors
	for floor_number in range(floors - 2):
		var next_floor_width = randi_range(min_tree_width, max_tree_width)

		var next_floor = []
		for j in range(next_floor_width):
			var new_node = map_node.new()
			new_node.randomize_node_type()
			print(new_node.node_type)
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
		
		map_object.append(previous_floor)
		previous_floor = next_floor

	map_object.append(previous_floor)

	var BOSS_FLOOR = map_node.new();
	BOSS_FLOOR.set_node_type("boss")
	for node in previous_floor:
		node.set_children([BOSS_FLOOR])

	map_object.append([BOSS_FLOOR])

	MAP = map_object

func endCombat():
	#current_combat.hide()
	#
	#current_combat.all_fighters = []
	#current_combat.current_fighter_index = 0;
	##var playing_queue_animation = false
	#current_combat.combat_state = "intro"
	#current_combat.animation_sub_state = null
	#current_combat.reward_screen_delay_counter = 0;
	var temp_party = []
	for party_member in current_combat.all_fighters:
		if party_member.player_controlled:
			var temp_bug = basic_bug.instantiate()
			temp_bug.health = party_member.health
			temp_bug.speed = party_member.speed
			temp_bug.evasion = party_member.evasion
			temp_bug.strength = party_member.strength
			temp_bug.quips = party_member.quips
			temp_bug.sprite_path = party_member.sprite_path
			temp_bug.player_controlled = true
			for i in range (party_member.attacks_list.size()):
				temp_bug.attacks_list.append(createAttackFromId(party_member.attacks_list[i].id))
			temp_party.append(temp_bug)
			
	CURRENT_PARTY = temp_party
	print("=========================================")
	print("Party before memory clear:")
	print(CURRENT_PARTY)
	

	self.remove_child(current_combat)
	current_combat.queue_free()
	
	print("Party after memory clear:")
	print(CURRENT_PARTY)
	
	CURRENT_MAP_NODE.visited = true
	for thing in MAP[CURRENT_HEIGHT]:
		thing.travelable = false
		thing.map_button.scale.x = 1
		thing.map_button.scale.y = 1
	CURRENT_HEIGHT+=1
	for c_node in CURRENT_MAP_NODE.children:
		c_node.travelable = true


func endEvent():
	print("end event called")
	# var temp_party = []
	# for party_member in current_combat.all_fighters:
	# 	if party_member.player_controlled:
	# 		var temp_bug = basic_bug.instantiate()
	# 		temp_bug.health = party_member.health
	# 		temp_bug.speed = party_member.speed
	# 		temp_bug.evasion = party_member.evasion
	# 		temp_bug.strength = party_member.strength
	# 		temp_bug.quips = party_member.quips
	# 		temp_bug.sprite_path = party_member.sprite_path
	# 		temp_bug.player_controlled = true
			
	# 		for i in range (party_member.attacks_list.size()):
	# 			temp_bug.attacks_list.append(createAttackFromId(party_member.attacks_list[i].id))
			
	# 		temp_party.append(temp_bug)
			
	self.remove_child(current_event)
	current_event.queue_free()
	
	CURRENT_MAP_NODE.visited = true
	for thing in MAP[CURRENT_HEIGHT]:
		thing.travelable = false
		thing.map_button.scale.x = 1
		thing.map_button.scale.y = 1
	CURRENT_HEIGHT+=1
	for c_node in CURRENT_MAP_NODE.children:
		c_node.travelable = true	
		
func LoadGame():
	generate_map_tree(MAP_HEIGHT)
	CURRENT_MAP_NODE = MAP[0][0]
	
	# walkMap(MAP)

	var map_object = map.instantiate()
	map_object.INDEX_CONTROLLER = self
	get_node("/root/Index").add_child(map_object)
	map_object.draw_map(MAP)
	
	
	master_bug_dict = loadJsonManifest("res://descriptions/bug_manifest.json").bugs
	master_attack_dict = loadJsonManifest("res://descriptions/attack_manifest.json").attacks
	master_event_dict = loadJsonManifest("res://descriptions/event_manifest.json").events
	master_combat_encounter_dict = loadJsonManifest("res://descriptions/combat_encounter_manifest.json").encounters
	
	var starting_ant = createBugFromId(1, true)
	starting_ant.health = 9
	CURRENT_PARTY = [starting_ant]
	return
	loadCombatEncounter(1)
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused=false
	pass
# Called when the node enters the scene tree for the first time.

	#
	#var test_ant2 = createBugFromId(1)
	#test_ant.health = 4
	#test_ant2.health = 4
	#test_ant.player_controlled = true
	#test_ant2.player_controlled = true
	#var attack = preload_attack.new()
	#attack.attack_name = "Super Pinch"
	#
	#var attack2 = preload_attack.new()
	#attack2.attack_name = "Super Duper Pinch"
	#test_ant.attacks_list = [attack, attack2]
	#test_ant2.attacks_list = [attack, attack2]
	#CURRENT_PARTY.append(test_ant)
	#CURRENT_PARTY.append(test_ant2)
	##print("Asdsdsds")
	#var current_combat = basic_combat_scene.instantiate()
	#var scene_root = get_node("/root/Index/")
	#scene_root.add_child(current_combat)
	#
	#
	#current_combat.spawnPlayerTeam(CURRENT_PARTY)
	#
	#var evil_ant = createBugFromId(1)
	#var evil_ant2 = createBugFromId(1)
	#var evil_ant3 = createBugFromId(1)
	#evil_ant.speed = 2
	#evil_ant2.speed = 3
	#evil_ant3.speed = 3
	#
	#evil_ant.health = 2
	#evil_ant2.health = 3
	#evil_ant3.health = 3
	#evil_ant.attacks_list = [attack, attack2]
	#evil_ant2.attacks_list = [attack, attack2]
	#evil_ant3.attacks_list = [attack, attack2]
	#current_combat.spawnEnemyTeam([evil_ant, evil_ant2, evil_ant3])
	#current_combat.initCombatQueue()
	##print("B")
	#pass # Replace with function body.
#

# Conditions
func has_species_in_party(species):
	for bug in CURRENT_PARTY:
		if (bug.bug_type == species):
			return true
	return false
func has_room_in_party(required_spaces):
	return (4 - CURRENT_PARTY.size()) >= required_spaces
# Rewards
func selectRandomPartyMember():
	return randi_range(0, CURRENT_PARTY.size() - 1)
func add_health_rand(amount):
	CURRENT_PARTY[selectRandomPartyMember()].health += amount
func remove_health_rand(amount):
	var index = selectRandomPartyMember()
	CURRENT_PARTY[index].health -= amount
	if CURRENT_PARTY[index].health <= 0:
		CURRENT_PARTY.pop_at(index)
	
func add_party_member(bug_id):
	if (CURRENT_PARTY.size() >=4):
		return
	var temp_bug = createBugFromId(bug_id, true)
	CURRENT_PARTY.append(temp_bug)
	
	
func remove_party_member(index):
	CURRENT_PARTY.pop_at(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func UpdateSFX(state: bool):
	sfx=state

func UpdateBG(state: bool):
	bg=state
func UpdateVol(vol: float):
	volume=vol

func PauseGame():
	
	$"Menu-manager".LoadPause()
	get_tree().paused=true
