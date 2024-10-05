extends Node2D

var health = null
var speed = null
var evasion = null
var strength = null

var custom_name = "Antony"

var sprite_path = "basic_brown_ant.png"

var status_armored = 0
var status_flying = 0
var status_blinded = 0

var in_combat = false

var attacks_list = [];



func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if(event.is_pressed()):
			if in_combat:
				var combat = get_node("/root/Index/combat")
				#$selection.visible = true
				
				#print("pressed!")
			

func spawn_bug(params):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$selection.visible = false
	$Sprite2D.texture = load("res://textures/bug_sprites/" + sprite_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
