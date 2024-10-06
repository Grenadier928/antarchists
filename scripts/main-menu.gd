extends Node

var menu_manager =null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed() -> void:
	$"..".clear_scene(false,true)
	$"..".StartGame()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	

func _on_options_button_pressed() -> void:
	$"..".LoadOptions()
	pass


func _on_button_pressed() -> void:
	get_tree().paused=false
	$"..".LoadPause()# Replace with function body.
