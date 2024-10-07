extends Node2D

var all_fighters = []
var current_fighter_index = 0;
#var playing_queue_animation = false
var combat_state = "intro"
var animation_sub_state = null

var attack_button = preload("res://scenes/attack_button.tscn")
var index_manager = null
var attack_victim = null
var chosenAttack = null
var attack_will_hit = null
var reward_screen_delay_counter = 0;

var quip_state = "hide"
var full_quip_string = null
var quip_creation_counter = 0
var quip_display_counter = 0

func createQuip(quipDict):
	
	if quip_state == "show":
		return
	var display_quip_chance = .3
	var rng = RandomNumberGenerator.new()
	var value = rng.randf_range(0, 1)
	print(value)
	if not value < display_quip_chance:
		print("No quip due to chance")
		return
	
	print("Quips dict in function")
	print(quipDict)
	full_quip_string = quipDict[rng.randi_range(0, quipDict.size()-1)]
	
	print("Quip Dict Size:")
	print(quipDict.size())
	
	#print
	
	if full_quip_string == null:
		print("No quips found for ant")
		return
	$quips_holder.show()
	$quips_holder/quip.text = ""
	quip_state = "show"
	#full_quip_string = null
	quip_creation_counter = 0
	quip_display_counter = 0
	pass

func AnimateTurnQueue():
	combat_state = "queue_animation"
	pass

func startPlayerTurn():
	animation_sub_state = "bob_down"
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
			temp_button.attackobj = all_fighters[current_fighter_index].attacks_list[i]
			pass
		$attacks_list_paper.show()
		

func startTargeting(selectedAttack):
	chosenAttack = selectedAttack
	$attacks_list_paper.hide()
	for i in range (all_fighters.size()):
		if not all_fighters[i].player_controlled:
			all_fighters[i].reticle.visible = true

func startAttackMove(victim):
	combat_state = "attack_animation"
	animation_sub_state = "attacker_move_forward"
	for i in range (all_fighters.size()):
		all_fighters[i].reticle.visible = false
		all_fighters[i].selection_box.visible = false
	attack_victim = victim
	victim.shake_counter = 0
	attack_will_hit = true
	var upper_bound = 10
	var lower_bound = victim.evasion
	
	if lower_bound > 5:
		lower_bound = 5
		
	var rng = RandomNumberGenerator.new()
	var hit_prob = rng.randi_range(0, 10)
	
	if hit_prob < lower_bound:
		attack_will_hit = false
	
	
func applyAttackVictimDamage():
	#print(attack_victim)
	#print("ABCDE")
	print(chosenAttack.attack_name)
	var total_damage = chosenAttack.base_damage + all_fighters[current_fighter_index].strength
	attack_victim.takeDamage(total_damage)
	attack_victim.spawnFloatText(str(total_damage))
	if attack_victim.health <= 0:
		createQuip(attack_victim.quips["combat-self-death"])
		print("Victim Quips:")
		print(attack_victim.quips["combat-self-death"])
		createQuip(all_fighters[current_fighter_index].quips["combat-kill"])
		attack_victim.combat_portrait.queue_free()
		var temp_all_fighters = []
		var attack_victim_index = 0
		for i in range (all_fighters.size()):
			if all_fighters[i] != attack_victim:
				temp_all_fighters.append(all_fighters[i])
			else:
				attack_victim_index = i
		if attack_victim_index < current_fighter_index:
			current_fighter_index = current_fighter_index - 1
		all_fighters = temp_all_fighters
		attack_victim.queue_free()
	
	var player_team_left = false
	var enemy_team_left = false
	for i in range (all_fighters.size()):
		if all_fighters[i].player_controlled:
			player_team_left = true
		else:
			enemy_team_left = true
	if not player_team_left:
		combat_state = "defeat"
		$combat_banner_defeat.visible = true
	if not enemy_team_left:
		combat_state = "win"
		$combat_banner_win.visible = true
		#print("ADSSDADASDASDSADASDADSDSADDA")
				#print("Victim found")
				#var temp_all_fighters_a = all_fighters.slice(0,i)
				#var temp_all_fighters_b = all_fighters.slice(i,all_fighters.size())
				
	pass
	
func endAttackMove():
	animation_sub_state = ""
	combat_state = "queue_animation"

	
func ChangeTurn():
	current_fighter_index += 1

	
	for i in range (all_fighters.size()):
		all_fighters[i].ai_targeting_frames = 0
		all_fighters[i].ai_await_frames = 0
	if current_fighter_index >= all_fighters.size():
		current_fighter_index = 0
	
	#if all_fighters[current_fighter_index].player_controlled:
	all_fighters[current_fighter_index].selection_box.visible = true
	if all_fighters[current_fighter_index].player_controlled:
		startPlayerTurn()
	else:
		startEnemyTurn()
	#pass
func startEnemyTurn():
	animation_sub_state = "bob_down"
	combat_state = "enemy_turn"
	
	var players_dude_indexes = []
	var index_counter = 0
	for i in range (all_fighters.size()):
		if all_fighters[i].player_controlled:

			players_dude_indexes.append(index_counter)
		index_counter += 1
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(0, players_dude_indexes.size())
	attack_victim = all_fighters[players_dude_indexes[rand_x]]
	
	#chosenAttack
	var rand_attack = rng.randf_range(0, all_fighters[current_fighter_index].attacks_list.size())
	chosenAttack = all_fighters[current_fighter_index].attacks_list[rand_attack]
	
	#for i in range (all_fighters[current_fighter_index].attacks_list.size()):
		#.attacks_list.size()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	#full_quip_string = quipDict.pick_random()
	#$quips_holder.show()
	#$quips_holder/quip.text = ""
	#quip_state = "show"
	#full_quip_string = null
	#quip_creation_counter = 0
	#quip_display_counter = 0
	var delay_to_add_character = 4
	var display_full_quip_time = 70
	
	if quip_state == "show":
		quip_creation_counter += 1
		if quip_creation_counter > delay_to_add_character:
			quip_creation_counter = 0
			$quips_holder/quip.text = full_quip_string.substr(0, $quips_holder/quip.text.length() + 1)
		
		print(full_quip_string.length())
		print($quips_holder/quip.text.length())
		if $quips_holder/quip.text.length() >= full_quip_string.length() - 1:
			quip_display_counter += 1
		if quip_display_counter >= display_full_quip_time:
			quip_state == "hide"
			$quips_holder.hide()
	
	
	
	var delay_before_reward_screen = 60
	
	if combat_state == "win":
		reward_screen_delay_counter += 1
		
		if reward_screen_delay_counter >= delay_before_reward_screen:
			$reward_screen.visible = true
	
	var bob_amount = 40
	var bob_speed = 4
	var queue_speed = 15
	if combat_state == "enemy_turn" or combat_state == "player_turn":

		if animation_sub_state == "bob_down":
			
			if all_fighters[current_fighter_index].position.y <= -bob_amount:
				animation_sub_state =  "bob_up"

				return
			all_fighters[current_fighter_index].position.y -= bob_speed
		
		elif animation_sub_state ==  "bob_up":
			
			if all_fighters[current_fighter_index].position.y >= bob_amount:
				animation_sub_state =  "bob_down"

				return
			all_fighters[current_fighter_index].position.y += bob_speed
			
	#for i in range (all_fighters.size()):
	#	pass
		#all_fighters

	if combat_state == "queue_animation":
		var queue_animation_active = false
		#print(combat_state)
		for i in range (all_fighters.size()):
			#print("Index:" + str(i) + "  -  " + "Figther Index: " + str(current_fighter_index))
			if i == current_fighter_index:
				var added_motion_vector = Vector2(0,0)
				var phase_1_active = false
				var phase_2_active = false
				queue_speed = 30
				if all_fighters[i].combat_portrait.position.y < 300 and all_fighters[i].combat_portrait.position.x < 100:
					added_motion_vector.y += queue_speed
					phase_1_active = true
					queue_animation_active  =true
				elif all_fighters[i].combat_portrait.position.x < (all_fighters.size() - 1) * 300 and not phase_1_active:
					added_motion_vector.x += queue_speed
					phase_2_active = true
					queue_animation_active  =true
					#queue_animation_done_local = false
				elif all_fighters[i].combat_portrait.position.y > 0 and not phase_2_active and not phase_1_active:
					added_motion_vector.y -= queue_speed
					phase_1_active = true
					queue_animation_active  =true
					#queue_animation_done_local = false
				all_fighters[i].combat_portrait.position += added_motion_vector
			else:
				
				var steps_to_reach_i = 0
				var cur_location = current_fighter_index

				if (current_fighter_index < i):
					steps_to_reach_i = i - (current_fighter_index + 1)
				else: # current_fighter_index > i
					steps_to_reach_i = (all_fighters.size()-1) -(current_fighter_index - i)
					
				#print("x: " + str(current_fighter_index) + " i: " + str(i) + " steps_to_reach_i: " + str(steps_to_reach_i))


				var destined_location_x = 0
				destined_location_x = steps_to_reach_i * 300
				
				var added_motion_vector = Vector2(0,0) 
				if all_fighters[i].combat_portrait.position.x > destined_location_x:
					added_motion_vector.x -= queue_speed
					queue_animation_active = true
					pass
				all_fighters[i].combat_portrait.position += added_motion_vector
				pass
		
		if queue_animation_active == false:
			#print("CHange turn after queue refresh")
			ChangeTurn()
		pass
	
	elif combat_state == "attack_animation":
		var attacker_move_forward_frames = 40
		
		var attacker_move_forward_speed = 15
		
		if not all_fighters[current_fighter_index].player_controlled:
			attacker_move_forward_speed = -attacker_move_forward_speed
		
		
		var victim_shake_magnitude = 100

		var victim_shake_duration = 20
		var motion_vector = Vector2(0,0)
		
		if animation_sub_state == "attacker_move_forward":
			if all_fighters[current_fighter_index].moved_forward_frames < attacker_move_forward_frames:
				all_fighters[current_fighter_index].moved_forward_frames+=1
				motion_vector.x += attacker_move_forward_speed
			else:
				animation_sub_state = "victim_shake"
		if animation_sub_state == "victim_shake":
			if not attack_will_hit:
				animation_sub_state = "attacker_withdraw"
				attack_victim.spawnFloatText("Miss!")
			elif attack_victim.shake_counter < victim_shake_duration:
				attack_victim.shake_counter += 1
				var rng = RandomNumberGenerator.new()
				var rand_x = rng.randf_range(-victim_shake_magnitude, victim_shake_magnitude)
				var rand_y = rng.randf_range(-victim_shake_magnitude, victim_shake_magnitude)
				attack_victim.position = Vector2(rand_x, rand_y)
			else:
				animation_sub_state = "attacker_withdraw"
				all_fighters[current_fighter_index].sfx.stream = load("res://sounds/clip/" + chosenAttack.sound_effect)
				all_fighters[current_fighter_index].sfx.play()
				print("Playing sound!")
				applyAttackVictimDamage()
				
		if animation_sub_state == "attacker_withdraw":
			if all_fighters[current_fighter_index].moved_forward_frames > 0:
				motion_vector.x -= attacker_move_forward_speed
				all_fighters[current_fighter_index].moved_forward_frames-=1
			else:
				endAttackMove()
				print("Ended AI attack move")
		all_fighters[current_fighter_index].position += motion_vector
		#all_fighters[current_fighter_index]
	
	elif combat_state == "enemy_turn":
		if all_fighters[current_fighter_index].ai_await_frames < all_fighters[current_fighter_index].const_ai_await_frames:
			all_fighters[current_fighter_index].ai_await_frames +=1
			#print(all_fighters[current_fighter_index].ai_await_frames)
			return
		elif attack_victim.reticle.visible == false:
			#print("A")
			attack_victim.reticle.visible = true
		elif all_fighters[current_fighter_index].ai_targeting_frames < all_fighters[current_fighter_index].const_ai_targeting_frames:
			all_fighters[current_fighter_index].ai_targeting_frames +=1
		else:
			startAttackMove(attack_victim)
	pass
	

func initCombatQueue():
	#var sorter = Sorter.new()
	all_fighters.sort_custom(func(a,b): return a.speed > b.speed)

	for i in range (all_fighters.size()):
		var port_bg = Sprite2D.new()
		var bg_texture = null
		if all_fighters[i].player_controlled:
			bg_texture = "portraitbg_GREEN.png"
		else:
			bg_texture = "portraitbg_RED.png"
		port_bg.texture = load("res://textures/" + bg_texture)
		port_bg.position = Vector2(i * 300,0)
		port_bg.scale = Vector2(.6,.6)
		
		$attack_queue.add_child(port_bg)
		all_fighters[i].combat_portrait = port_bg
		all_fighters[i].drawSprite()
		var sub_port = Sprite2D.new()
		sub_port.texture = load("res://textures/bug_sprites/" + all_fighters[i].sprite_path)
		sub_port.position = Vector2(0,0)
		sub_port.scale = Vector2(.8,.8)
		port_bg.add_child(sub_port)
		#all_fighters[i].combat_portrait = port
		#print("BBB")
		#$attack_queue.add_child(port_bg)
		if not all_fighters[i].player_controlled:
			all_fighters[i].sprite_node.scale.x = -1
	#	all_fighters_temp.append(all_fighters[i])
	current_fighter_index = 0
	
	if all_fighters[0].player_controlled:
		startPlayerTurn()
	else:
		startEnemyTurn()
	#ChangeTurn()
	pass

func spawnPlayerTeam(player_team):
	#print(player_team)
	var player_spawns = [
		$player_team_position_0,
		$player_team_position_1,
		$player_team_position_2,
		$player_team_position_3
	]
	

	for i in range (player_team.size()):
		all_fighters.append(player_team[i])
		#$player_team_position_0
		print("Player team index i:")
		print(player_team[i])
		player_spawns[i].add_child(player_team[i])

		#get_node("/root/Index/Combat/player_team_position_" + str(i)).add_child(player_team[i])
		player_team[i].combat_manager = null
		print("Com managwer:")
		print(player_team[i].combat_manager)
		player_team[i].combat_manager = self
	#$player_team_position_1.add_child(player_team[0])
	#print($player_team_position_1.position)
	#player_team[0].position = $player_team_position.global_position#Vector2(0,0)
	player_team[0].position = Vector2(0,0)
	player_team[0].in_combat = true
	pass
	
func spawnEnemyTeam(enemy_team):
	#print("AAAAFDSDFASDSSSSSSSSSSSSSSSSSSSSSSS")
	
	var enemy_spawns = [
		$enemy_team_position_0,
		$enemy_team_position_1,
		$enemy_team_position_2,
		$enemy_team_position_3
	]
	
	for i in range (enemy_team.size()):
	#	print("AAAAFDSDFASD")
		all_fighters.append(enemy_team[i])
		enemy_team[i].combat_manager = self
		#get_node("/root/Index/Combat/enemy_team_position_" + str(i)).add_child(enemy_team[i])
		enemy_spawns[i].add_child(enemy_team[i])
	pass


func _on_continue_pressed() -> void:
	index_manager.endCombat()
	pass # Replace with function body.
