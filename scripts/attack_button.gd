extends Button

var combat_manager = null
var attack_index = null
var attackobj = null
# Called when the node enters the scene tree for the first time.
func _ready():
	#connect(self._button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	print("Pressed")
	combat_manager.startTargeting(attackobj)
	pass # Replace with function body.
