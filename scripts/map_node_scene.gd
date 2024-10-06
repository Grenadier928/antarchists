extends TextureButton

var map_controller = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	map_controller.testFunc()
