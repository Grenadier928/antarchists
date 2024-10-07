extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	get_tree().paused =false
	$"..".Unpause()
	


func _on_options_button_pressed() -> void:# Replace with function body.
	$"..".LoadOptions()



func _on_quit_button_pressed() -> void:
	$confirm.show()
	$Buttons.hide()
	



func _on_no_pressed() -> void:
	$confirm.hide()
	$Buttons.show()


func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/index.tscn")
