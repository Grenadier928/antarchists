extends Node2D

var dict_event = null
var index_manager = null


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
	
	pass
	
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
