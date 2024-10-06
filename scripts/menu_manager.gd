extends Node2D

var scene_stack = []
var current_menu=null
var main_menu_instance = null
var options_instance = null
var pause_instance = null
var MANAGER = null
var MAIN_MENU
var OPTIONS
var PAUSE
func push_scene(scene_path):
	scene_stack.append(scene_path)

func pop_scene():
	if scene_stack.size() > 0:
		var last=scene_stack.pop_back()
		return last
	return null

func clear_scene(full_clear,remove):
	if scene_stack.back() == self:
		
		#NOTHING IN THE STACK, NOTHING TO POP
		pass
	else:
		if full_clear:
			var inst = scene_stack.back()
			if inst is Node or inst is Control :
				inst.queue_free()
		else:
			var inst = scene_stack.back()
			if inst is Node or inst is Control:
				remove_child(inst)
		if scene_stack.size() > 1 and remove:
			scene_stack.pop_back()
			
func LoadOnTop(full_clear):
	if scene_stack.back() == self:
		
		#NOTHING IN THE STACK, NOTHING TO POP
		pass
	else:
		if full_clear:
			var inst = scene_stack.back()
			if inst is Node or inst is Control :
				inst.queue_free()
		else:
			var inst = scene_stack.back()
			if inst is Node or inst is Control:
				(inst).hide()
			
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	MAIN_MENU = preload("res://scenes/main-menu.tscn")
	OPTIONS = preload("res://scenes/options.tscn")
	PAUSE = preload("res://scenes/pause-menu.tscn")
	$options.INDEX = $".."
	LoadMainMenu()
	#$"Main-menu".

func StartGame():
	if current_menu:
		current_menu.hide()
		current_menu=null
	$"..".LoadGame()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func LoadMainMenu():
	if current_menu:
		current_menu.hide()
	$"Main-menu".show()
	current_menu=$"Main-menu"
	#if not main_menu_instance:
		#main_menu_instance = MAIN_MENU.instantiate()
		#
	##if get_tree().current_scene:
		##get_tree().current_scene.queue_free()
	#if main_menu_instance:
		#add_child(main_menu_instance)
		#current_menu = main_menu_instance
		#push_scene(main_menu_instance)
		


func LoadOptions():
	
	if current_menu:
		push_scene(current_menu)
		current_menu.hide()
	
	$options.show()
	current_menu=$options
	#LoadOnTop(false)
	#if not options_instance:
		#options_instance= OPTIONS.instantiate()
		#
	#if options_instance:
		#add_child(options_instance)
		#push_scene(options_instance)
func UnloadOptions():
	if current_menu == $options:
		current_menu.hide()
	current_menu= pop_scene()
	current_menu.show()
func LoadPause():
	if not pause_instance:
		pause_instance = PAUSE.instantiate()
		
	#if get_tree().current_scene:
		#get_tree().current_scene.queue_free()
	if pause_instance:
		add_child(pause_instance)
		current_menu = pause_instance
		push_scene(pause_instance)
		
func GoBack(full_clear):
	if scene_stack.back() == self:
		
		#NOTHING IN THE STACK, NOTHING TO GO BACK
		pass
	else:
		if full_clear:
			var inst = scene_stack.back()
			if inst is Node or inst is Control :
				inst.queue_free()
		else:
			var inst = scene_stack.back()
			if inst is Node or inst is Control :
				remove_child(inst)
		if scene_stack.size() > 1:
			scene_stack.pop_back()
		var prev_scene= scene_stack.back()
		if not prev_scene == self:
			prev_scene.show()  #ASSUMING THIS IS NEVER FULL CLEARED
			
	
func Unpause():
	if current_menu == $"pause-menu":
		current_menu.hide()
		current_menu=null
		
func AdjustVolume(vol:float):
	$"..".volume=vol

func SetSFX(state:bool):
	$"..".sfx=state
	
func SetBG(state:bool):
	$"..".bg=state


		
