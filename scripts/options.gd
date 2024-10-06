extends Control

var INDEX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Controls/SFXButton.button_pressed=true
	$Controls/BGButton.button_pressed=true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_done_button_pressed() -> void:
	$"..".UnloadOptions()


func _on_volume_slider_value_changed(value: float) -> void:
	INDEX.UpdateVol($Controls/VolumeSlider.value)


func _on_bg_button_pressed() -> void:
	INDEX.UpdateBG($Controls/BGButton.button_pressed)


func _on_sfx_button_pressed() -> void:
	#print($Controls/SFXButton.button_pressed)
	INDEX.UpdateSFX($Controls/SFXButton.button_pressed)
