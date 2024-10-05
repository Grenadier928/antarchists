extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("YAYA")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnPlayerTeam(player_team):
	#print(player_team)
	$player_team_position_1.add_child(player_team[0])
	#print($player_team_position_1.position)
	#player_team[0].position = $player_team_position.global_position#Vector2(0,0)
	player_team[0].position = Vector2(0,0)
	pass
	
func spawnEnemyTeam():
	pass
