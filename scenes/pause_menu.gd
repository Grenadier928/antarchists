extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	get_tree().paused =false
	print("BUTTON PRESED")
	$"..".clear_scene(false,true)
	


func _on_options_button_pressed() -> void:# Replace with function body.
	$"..".LoadOptions()



func _on_quit_button_pressed() -> void:
	print("HE CLLA")
	$confirm.show()
	$VBoxContainer.hide()
	



func _on_no_pressed() -> void:
	$confirm.hide()
	$VBoxContainer.show()


func _on_yes_pressed() -> void:
	pass # Replace with function body.
