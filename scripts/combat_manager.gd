extends Node2D

var all_fighters = []
var current_fighter_index = 0;
var playing_queue_animation = false
var fight_state = "intro"

var attack_button = preload("res://scenes/attack_button.tscn")
#var queue_animation_done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("YAYA")
	#$attacks_list_paper.visible = false
	pass # Replace with function body.

func AnimateTurnQueue():
	#queue_animation_done = false
	playing_queue_animation = true
	#all_fighters[current_fighter_index].combat_portrait.position = Vector2(all_fighters.size() * 300,0)
	#for i in range (all_fighters.size()):
	#	all_fighters[i].combat_portrait.position = Vector2(all_fighters[i].position.x + 300,0)
	#current_fighter_index += 1
	pass

func startBugTurn():
	
	if all_fighters[current_fighter_index].player_controlled:
		all_fighters[current_fighter_index].selection_box.visible = true
		for i in range (all_fighters[current_fighter_index].attacks_list.size()):
			var temp_button = attack_button.instantiate()
			temp_button.text = all_fighters[current_fighter_index].attacks_list[i].attack_name
			$attacks_list_paper.add_child(temp_button)
			temp_button.position = Vector2(-1200, (700 * i) - 700)
			temp_button.combat_manager = self
			pass
			#var attack_button = Button.new()
			#attack_button.size = Vector2(3000, 600)
			#attack_button.text = all_fighters[current_fighter_index].attacks_list[i].attack_name
			#attack_button.position = Vector2(-1500, -1500)
			#attack_button.add_theme_font_size_override("font_size", 200)
			#$attacks_list_paper.add_child(attack_button)
		$attacks_list_paper.show()
		

func startTargeting():
	$attacks_list_paper.hide()
	for i in range (all_fighters.size()):
		if not all_fighters[i].player_controlled:
			all_fighters[i].reticle.visible = true


func ChangeTurn():
	#all_fighters.size()
	pass
	#if current_fighter_index != -1:
	#	AnimateTurnQueue()
	#current_fighter_index += 1
	
	#if all_fighters[current_fighter_index].player_controlled:
	#	all_fighters[current_fighter_index].selection_box.visible = true
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var queue_speed = 15
	#print("0")
	if playing_queue_animation:
		var queue_animation_done_local = false
		for i in range (all_fighters.size()):
			if i == current_fighter_index:
				var added_motion_vector = Vector2(0,0)
				var phase_1_active = false
				var phase_2_active = false
				if all_fighters[i].combat_portrait.position.y < 300 and all_fighters[i].combat_portrait.position.x < 100:
					added_motion_vector.y += queue_speed
					phase_1_active = true
					queue_animation_done_local = false
				elif all_fighters[i].combat_portrait.position.x < (all_fighters.size() - 1) * 300 and not phase_1_active:
					added_motion_vector.x += queue_speed
					phase_2_active = true
					queue_animation_done_local = false
				elif all_fighters[i].combat_portrait.position.y > 0 and not phase_2_active and not phase_1_active:
					added_motion_vector.y -= queue_speed
					phase_1_active = true
					queue_animation_done_local = false
				else:
					queue_animation_done_local = true
				all_fighters[i].combat_portrait.position += added_motion_vector
				#print(all_fighters[i].combat_portrait.position)
				#all_fighters[current_fighter_index].combat_portrait.position = Vector2(all_fighters.size() * 300,0)
			else:
				
				#for let i = 
				var destined_location_x = 0
				var current_while_index = current_fighter_index
				var caught_index = false
				
				while destined_location_x < (all_fighters.size() - 1) * 300:
					if current_while_index == current_fighter_index:
						break
					destined_location_x += 300
					current_while_index += 1
					if current_while_index == all_fighters.size():
						current_while_index = 0
				
				
				var added_motion_vector = Vector2(0,0) 
				if all_fighters[i].combat_portrait.position.x > destined_location_x:
					added_motion_vector.x -= queue_speed
					queue_animation_done_local = false
					pass
				else:
					queue_animation_done_local = true
				all_fighters[i].combat_portrait.position += added_motion_vector
				pass

		pass
	pass
	
func _input(ev):
	if Input.is_key_pressed(KEY_K):
		playing_queue_animation = true
		#print("BBBBBBBB")
		
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
		if not all_fighters[i].player_controlled:
			all_fighters[i].sprite_node.scale.x = -1
	#	all_fighters_temp.append(all_fighters[i])
	current_fighter_index = 0
	startBugTurn()
	#ChangeTurn()
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
