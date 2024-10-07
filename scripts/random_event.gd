extends Node2D

var dict_event = null
var index_manager = null
var results
var is_event_finished = false;
var exit_event_delay = 60;

var event_button = preload("res://scenes/random_event_button.tscn")
var added_buttons_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(event_data, index_script):
	index_manager = index_script
	dict_event = event_data
	loadEventData(dict_event.title, dict_event.description)
	pass
	
func loadEventData(title, description):
	$description.text = description
	$title.text = title
	spawnChoiceButtons()
	
func evaluateOptionValid(option):
	print(option)
	print(option.has('conditions'))
	if not option.has('conditions'):
		return true
	else:
		print("AAAAA")
		return true
	
func spawnChoiceButtons():
	for i in range (dict_event.options.size()):
		#pass
		if evaluateOptionValid(dict_event.options[i]) == true:
			addOptionButton(dict_event.options[i])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func rollResult(selected_option):
	var rng = RandomNumberGenerator.new()
	var random_val = rng.randf_range(0, 1)
	
	var final_outcome = null
	for outcome in selected_option.results:
		var weight = outcome.prob

		if (weight >= random_val):
			final_outcome = outcome
			break
		random_val -= weight
	#if selected_option.results.size() == 1:
		#final_outcome = selected_option.results[0]
		#results = final_outcome.results
		#print("FINAL OUTCOME")
		#print(final_outcome.keys())
		#if "results" in results.keys():
			#final_outcome=results.results
	$description.text = final_outcome.description
	$title.text = final_outcome.title
	$choices_holder.hide()
	#var random_float = rng.randf_range(0, 1)
	#
	#var best_outcome = null
	#var smallest_distance = 100
	#
	#for outcome in selected_option.results:
		#var temp_dist = abs(outcome.prob - random_float)
		#if temp_dist < smallest_distance:
			#best_outcome = outcome
	
	for key in (final_outcome.results.keys()):
		match (key):
			"add_health_rand":
				index_manager.add_health_rand(final_outcome.results[key])
			"remove_health_rand":
				index_manager.remove_health_rand(final_outcome.results[key])
				if index_manager.CURRENT_PARTY.size()<1:
					$combat_banner_defeat.show()
					get_tree().pause=true
			"add_party_member":
				index_manager.add_party_member(final_outcome.results[key])
			"remove_part_member":
				index_manager.remove_party_member(final_outcome.results[key])

	is_event_finished = true;
	
	pass

func _physics_process(delta: float) -> void:
	var delay_before_exit = 60

	if is_event_finished:
		exit_event_delay -= 1

		if exit_event_delay <= 0 :
			print("ENDING EVENT")
			index_manager.endEvent()

	
func addOptionButton(option):
	var temp_button = event_button.instantiate()
	$choices_holder.add_child(temp_button)
	temp_button.text = option.text
	added_buttons_count += 1
	if option.has('conditions'):
		#print("BBB")
		temp_button.set("theme_override_colors/font_color", Color(0.0,0.0,1.0,1))
	temp_button.position = Vector2(0, 250 * added_buttons_count)
	temp_button.event_script = self
	temp_button.option_details = option
	pass
