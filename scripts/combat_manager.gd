extends Node2D

var all_fighters = []
var current_fighter_index = 0;
#var playing_queue_animation = false
var combat_state = "intro"
var animation_sub_state = null

var attack_button = preload("res://scenes/attack_button.tscn")

var attack_victim = null
#var queue_animation_done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("YAYA")
	#$attacks_list_paper.visible = false
	pass # Replace with function body.

func AnimateTurnQueue():
	#queue_animation_done = false
	#playing_queue_animation = true
	combat_state = "queue_animation"
	#all_fighters[current_fighter_index].combat_portrait.position = Vector2(all_fighters.size() * 300,0)
	#for i in range (all_fighters.size()):
	#	all_fighters[i].combat_portrait.position = Vector2(all_fighters[i].position.x + 300,0)
	#current_fighter_index += 1
	pass

func startBugTurn():
	
	if all_fighters[current_fighter_index].player_controlled:
		combat_state = "player_turn"
		all_fighters[current_fighter_index].selection_box.visible = true
		for i in range (all_fighters[current_fighter_index].attacks_list.size()):
			var temp_button = attack_button.instantiate()
			temp_button.text = all_fighters[current_fighter_index].attacks_list[i].attack_name
			$attacks_list_paper.add_child(temp_button)
			temp_button.position = Vector2(-1200, (700 * i) - 700)
			temp_button.combat_manager = self
			temp_button.attack_index = i
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

func startAttackMove(victim):
	combat_state = "attack_animation"
	animation_sub_state = "attacker_move_forward"
	attack_victim = victim
	victim.shake_counter = 0
	
func applyAttackVictimDamage():
	pass
	
func endAttackMove():
	animation_sub_state = ""
	combat_state = "queue_animation"
	#ChangeTurn()
	
func ChangeTurn():
	pass
	#all_fighters.size()
	#pass
	#if current_fighter_index != -1:
	#	AnimateTurnQueue()
	#current_fighter_index += 1
	
	#if all_fighters[current_fighter_index].player_controlled:
	#	all_fighters[current_fighter_index].selection_box.visible = true
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var bob_amount = 10
	for i in range (all_fighters.size()):
		pass
		#all_fighters
	
	
	var queue_speed = 15
	#print("0")
	#if playing_queue_animation:
	if combat_state == "queue_animation":
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
				
				var steps_to_reach_i = 0
				var cur_location = current_fighter_index
				while true:
					cur_location += 1
					if cur_location == i:
						break
					steps_to_reach_i += 1
					if cur_location > all_fighters.size():
						cur_location = 0;
				destined_location_x = steps_to_reach_i * 300
				#destined_location_x = min(abs(i - current_fighter_index), all_fighters.size() - abs(i - current_fighter_index))
				#print(destined_location_x)
				#destined_location_x = destined_location_x - 1
				#destined_location_x = destined_location_x * 300
				#if i < current_fighter_index:
					#destined_location_x = i * 300
					#for j in range (all_fighters.size() - current_fighter_index):
					#	destined_location_x = (300 * j)
				#if i < current_fighter_index:
				#	for j in range (current_fighter_index):
				#		destined_location_x = (300 * j) + ((all_fighters.size() - current_fighter_index) * 300)
				#var current_while_index = current_fighter_index
				print(destined_location_x)
				#while true:
				#	if current_while_index == current_fighter_index:
				#		break
				#	destined_location_x += 300
				#	current_while_index += 1
				#	if current_while_index == all_fighters.size():
				#		current_while_index = 0
				
				
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
	
	elif combat_state == "attack_animation":
		var attacker_move_forward_distance = 160
		var attacker_move_forward_speed = 20
		
		var victim_shake_magnitude = 100
		#var victim_shake_counter = attack_victim.shake_counter
		var victim_shake_duration = 20
		var motion_vector = Vector2(0,0)
		
		
		
		if animation_sub_state == "attacker_move_forward":
			if all_fighters[current_fighter_index].position.x < attacker_move_forward_distance:
				motion_vector.x += attacker_move_forward_speed
			else:
				animation_sub_state = "victim_shake"
				applyAttackVictimDamage()
		if animation_sub_state == "victim_shake":
			#animation_sub_state = "victim_shake"
			if attack_victim.shake_counter < victim_shake_duration:
				attack_victim.shake_counter += 1
				#attack_victim.position = Vector2(0,0)
				var rng = RandomNumberGenerator.new()
				var rand_x = rng.randf_range(-victim_shake_magnitude, victim_shake_magnitude)
				var rand_y = rng.randf_range(-victim_shake_magnitude, victim_shake_magnitude)
				attack_victim.position = Vector2(rand_x, rand_y)
			else:
				animation_sub_state = "attacker_withdraw"
				
		if animation_sub_state == "attacker_withdraw":
			if all_fighters[current_fighter_index].position.x > 0:
				motion_vector.x -= attacker_move_forward_speed
			else:
				endAttackMove()
		all_fighters[current_fighter_index].position += motion_vector
		#all_fighters[current_fighter_index]
	
	pass
	
func _input(ev):
	if Input.is_key_pressed(KEY_K):
		combat_state = "queue_animation"
		#playing_queue_animation = true
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
		player_team[i].combat_manager = self
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
		enemy_team[i].combat_manager = self
		get_node("/root/Index/Combat/enemy_team_position_" + str(i)).add_child(enemy_team[i])
	pass
