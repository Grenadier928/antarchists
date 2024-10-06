extends Label

var current_alpha_val = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var float_off_speed = 5
	var fade_speed = .02
	current_alpha_val -= fade_speed
	position.y -= float_off_speed
	#theme.set_color(Color(255,255,255,255))
	set("theme_override_colors/font_color", Color(1.0,1.0,1.0,current_alpha_val))
	pass
