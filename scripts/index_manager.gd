extends Node2D

var basic_combat_scene = preload("res://scenes/combat.tscn")

var basic_bug = preload("res://scenes/bug.tscn")
var preload_attack = preload("res://scripts/attack.gd")

var CURRENT_PARTY = []

func loadData(FilePath):
	if FileAccess.file_exists(FilePath):
		var data = FileAccess.open(FilePath, FileAccess.READ)
		var ParsedResults = JSON.parse_string(data.get_as_text())

		if ParsedResults is Dictionary:
			return ParsedResults
		else:
			print("File read error!")
	else:
		print("No such file!")

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = FileAccess.open("res://descriptions/attack_manifest.json", FileAccess.READ)
	var json_text = test.get_as_text()
	test.close()
	var json = JSON.new()
	var temp_json = json.parse(json_text)
	var data_received = json.data#.attacks[0]
	print(data_received)
	data_received = json.data.attacks[0]
	print(data_received)
	data_received = json.data.attacks[0].name
	print(data_received)
	#print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	var test_ant = basic_bug.instantiate()
	var test_ant2 = basic_bug.instantiate()
	test_ant.speed = 1
	test_ant2.speed = 1
	test_ant.health = 5
	test_ant2.health = 1
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
	
	var evil_ant = basic_bug.instantiate()
	var evil_ant2 = basic_bug.instantiate()
	var evil_ant3 = basic_bug.instantiate()
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
