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
	if not option.has('conditions'):
		return true
	else:
		print("AAAAA")
	
func spawnChoiceButtons():
	for i in range (dict_event.options.size()):
		#pass
		if evaluateOptionValid(dict_event.options[i]) == true:
			addOptionButton(dict_event.options[i])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func addOptionButton(option):
	var temp_button = event_button.instantiate()
	$choices_holder.add_child(temp_button)
	temp_button.text = option.text
	added_buttons_count += 1
	temp_button.position = Vector2(0, 250 * added_buttons_count)
	pass
