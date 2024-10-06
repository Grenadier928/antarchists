extends Node2D

var basic_combat_scene = preload("res://scenes/combat.tscn")
var basic_event_scene = preload("res://scenes/random_event.tscn")

var basic_bug = preload("res://scenes/bug.tscn")
var preload_attack = preload("res://scripts/attack.gd")

var CURRENT_PARTY = []
var CURRENT_ITEMS = []
var CURRENT_FLOOR = 0

var master_bug_dict = null
var master_attack_dict = null
var master_event_dict = null
var master_combat_encounter_dict = null

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
		if master_bug_dict[i].id == id:
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
	var current_event = basic_event_scene.instantiate()
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
	var dict_entry = null
	for i in range (master_combat_encounter_dict.size()):
		#print(master_bug_dict[i])
		if master_combat_encounter_dict[i].id == combat_encounter_id:
			dict_entry = master_combat_encounter_dict[i]
			break
	var current_combat = basic_combat_scene.instantiate()
	var scene_root = get_node("/root/Index/")
	scene_root.add_child(current_combat)
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
		
# Called when the node enters the scene tree for the first time.
func _ready():
	master_bug_dict = loadJsonManifest("res://descriptions/bug_manifest.json").bugs
	master_attack_dict = loadJsonManifest("res://descriptions/attack_manifest.json").attacks
	master_event_dict = loadJsonManifest("res://descriptions/event_manifest.json").events
	master_combat_encounter_dict = loadJsonManifest("res://descriptions/combat_encounter_manifest.json").encounters
	
	var starting_ant = createBugFromId(1, true)
	CURRENT_PARTY = [starting_ant]
	loadCombatEncounter(1)
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
