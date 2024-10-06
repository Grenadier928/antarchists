extends Node2D

var basic_combat_scene = preload("res://scenes/combat.tscn")

var basic_bug = preload("res://scenes/bug.tscn")
var preload_attack = preload("res://scripts/attack.gd")

var CURRENT_PARTY = []
var master_bug_dict = null

func createBugFromId(id):
	var dict_entry = null
	for i in range (master_bug_dict.size()):
		#print(master_bug_dict[i])
		if master_bug_dict[i].id == id:
			dict_entry = master_bug_dict[i]
			break
	var temp_bug = basic_bug.instantiate()
	temp_bug.health = dict_entry.health
	temp_bug.speed = dict_entry.speed
	temp_bug.strength = dict_entry.strength
	temp_bug.quips = dict_entry.quips
	temp_bug.sprite_path = dict_entry.sprite_path
	#temp_bug.init()
	return temp_bug


# Called when the node enters the scene tree for the first time.
func _ready():
	var raw_file = FileAccess.open("res://descriptions/bug_manifest.json", FileAccess.READ)
	var raw_json = raw_file.get_as_text()
	raw_file.close()
	var json_reader = JSON.new()
	var temp_json = json_reader.parse(raw_json)
	var data_received = json_reader.data#.attacks[0]
	master_bug_dict = json_reader.data.bugs
	#createBugFromId(1)
	#print(master_bug_dict)
	#print(data_received)
	#data_received = json_reader.data.attacks[0]
	#print(data_received)
	#data_received = json_reader.data.attacks[0].name
	#print(data_received)
	#print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	var test_ant = createBugFromId(1)
	var test_ant2 = createBugFromId(1)

	test_ant.player_controlled = true
	test_ant2.player_controlled = true
	var attack = preload_attack.new()
	attack.attack_name = "Super Pinch"
	
	var attack2 = preload_attack.new()
	attack2.attack_name = "Super Duper Pinch"
	test_ant.attacks_list = [attack, attack2]
	test_ant2.attacks_list = [attack, attack2]
	CURRENT_PARTY.append(test_ant)
	CURRENT_PARTY.append(test_ant2)
	#print("Asdsdsds")
	var current_combat = basic_combat_scene.instantiate()
	var scene_root = get_node("/root/Index/")
	scene_root.add_child(current_combat)
	
	
	current_combat.spawnPlayerTeam(CURRENT_PARTY)
	
	var evil_ant = createBugFromId(1)
	var evil_ant2 = createBugFromId(1)
	var evil_ant3 = createBugFromId(1)
	evil_ant.speed = 2
	evil_ant2.speed = 3
	evil_ant3.speed = 3
	
	evil_ant.health = 2
	evil_ant2.health = 3
	evil_ant3.health = 3
	evil_ant.attacks_list = [attack, attack2]
	evil_ant2.attacks_list = [attack, attack2]
	evil_ant3.attacks_list = [attack, attack2]
	current_combat.spawnEnemyTeam([evil_ant, evil_ant2, evil_ant3])
	current_combat.initCombatQueue()
	#print("B")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
