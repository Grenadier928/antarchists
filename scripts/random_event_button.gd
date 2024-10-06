extends Button

var option_details = null
var event_script = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print(option_details)
	event_script.rollResult(option_details)
	pass # Replace with function body.
