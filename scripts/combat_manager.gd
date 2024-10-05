extends Node2D

var all_fighters = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print("YAYA")
	pass # Replace with function body.

func AnimateTurnQueue():
	pass

func setSelectedBug(selection):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
	
func initCombatQueue():
	#var sorter = Sorter.new()
	all_fighters.sort_custom(func(a,b): return a.speed < b.speed)
	print(all_fighters)
	for i in range (all_fighters.size()):
		var port = Sprite2D.new()
		port.texture = load("res://textures/bug_sprites/" + all_fighters[i].sprite_path)
		port.position = Vector2(i * 300,0)
		port.scale = Vector2(.4,.4)
		all_fighters[i].combat_portrait = port
		#print("BBB")
		$attack_queue.add_child(port)
	#	all_fighters_temp.append(all_fighters[i])
	pass

func spawnPlayerTeam(player_team):
	#print(player_team)
	for i in range (player_team.size()):
		all_fighters.append(player_team[i])
		get_node("/root/Index/Combat/player_team_position_" + str(i)).add_child(player_team[i])
	#$player_team_position_1.add_child(player_team[0])
	#print($player_team_position_1.position)
	#player_team[0].position = $player_team_position.global_position#Vector2(0,0)
	player_team[0].position = Vector2(0,0)
	player_team[0].in_combat = true
	pass
	
func spawnEnemyTeam(enemy_team):
	#print("AAAAFDSDFASDSSSSSSSSSSSSSSSSSSSSSSS")
	for i in range (enemy_team.size()):
	#	print("AAAAFDSDFASD")
		all_fighters.append(enemy_team[i])
		get_node("/root/Index/Combat/enemy_team_position_" + str(i)).add_child(enemy_team[i])
	pass
