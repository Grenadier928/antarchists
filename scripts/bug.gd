extends Node2D

var health = null
var speed = null
var evasion = null
var strength = null

var custom_name = "Antony"

var sprite_path = "LTLEECH.png"

var status_armored = 0
var status_flying = 0
var status_blinded = 0

var combat_manager = null
var in_combat = false
var combat_portrait = null
var player_controlled = false

var const_ai_await_frames = 70
var const_ai_targeting_frames = 20


var ai_await_frames = 0
var ai_targeting_frames = 0
var ai_targeting_node = null

var attacks_list = [];

var selection_box = null
var sprite_node = null
var reticle = null

var shake_counter = 0

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
	#$sfx.stream = load("res://sounds/clip/slice.wav")
	#$sfx.play()
	
	
	selection_box = $active_selection
	selection_box.visible = false
	
	reticle = $reticle
	
	#print(reticle)
	reticle.visible = false
	sprite_node = $character_art
	sprite_node.texture = load("res://textures/bug_sprites/" + sprite_path)
	#print(sprite_path)
	#print(sprite_node.texture)
	#sprite_node.texture = load("res://textures/bug_sprites/paper.jpg")
	#print(sprite_node)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reticle_pressed() -> void:
	#var combat = get_node("/root/Index/combat")
	#print(combat_manager)
	combat_manager.startAttackMove(self)
	pass # Replace with function body.
