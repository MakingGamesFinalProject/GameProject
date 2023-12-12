extends Node2D
var collidingPlayers = []

@export var startButton := false

@export var controlsButton := false

@export var quitButton := false

@export var loadingScreen:PackedScene ## calling it loading screen since it should go there first.

@export var controlsUI:PackedScene 


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D  
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collidingPlayers.size() == 2:
		menuChoose()
		
		pass
	elif collidingPlayers.size() == 0:
			$ProgressBar.value = 0
			pass
	pass

func menuChoose(): # used to increase and load the next scene based on the menu
	$ProgressBar.value += 0.5
	if $ProgressBar.value == 100:
		if startButton == true:
			get_tree().change_scene_to_packed(loadingScreen)
			return
		if name == "Controls":
			get_tree().change_scene_to_packed(controlsUI)
			return
		if name == "Quit":
			get_tree().quit()
			return


func _on_area_2d_body_entered(body): ## checks how many bodies are 
	collidingPlayers =	$Area2D.get_overlapping_bodies()
	pass # Replace with function body.
	



func _on_area_2d_body_exited(body): ## Checks that there is still two people on it
	collidingPlayers =	$Area2D.get_overlapping_bodies()
	pass # Replace with function body.
