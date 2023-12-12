extends Node2D
var collidingPlayers = []

@export var startButton := false

@export var controlsButton := false

@export var quitButton := false

@export var loadingScreen:PackedScene ## calling it loading screen since it should go there first.

@export var controlsUI:PackedScene 

@export var texture: Texture


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D  
	if(texture != null):
		$Sprite2D.texture = texture
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
			get_parent().get_parent().get_node("ControlsUI").set_visible(true)
			get_parent().get_parent().get_node("MainMenuButtons").set_visible(false)
			return
		if name == "Quit":
			get_tree().quit()
			return
		if name == "TabToController":
			get_parent().get_parent().get_node("Keyboard").set_visible(false)
			get_parent().get_parent().get_node("Controller").set_visible(true)
			self.set_visible(false)
			get_parent().get_node("TabToKeyboard").set_visible(true)
			return
		if name == "TabToKeyboard":
			get_parent().get_parent().get_node("Keyboard").set_visible(true)
			get_parent().get_parent().get_node("Controller").set_visible(false)
			self.set_visible(false)
			get_parent().get_node("TabToController").set_visible(true)
			return
		if name == "CloseControls":
			get_parent().get_parent().set_visible(false)
			get_parent().get_parent().get_parent().get_node("MainMenuButtons").set_visible(true)
			return


func _on_area_2d_body_entered(body): ## checks how many bodies are 
	collidingPlayers =	$Area2D.get_overlapping_bodies()
	pass # Replace with function body.
	



func _on_area_2d_body_exited(body): ## Checks that there is still two people on it
	collidingPlayers =	$Area2D.get_overlapping_bodies()
	pass # Replace with function body.
