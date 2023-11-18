extends Node

var next_play_section := false

@onready var players := {
	"1": {
		viewport = $HBoxContainer/SubViewportContainer/SubViewport,
		camera = $HBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $HBoxContainer/SubViewportContainer/SubViewport/Node/Player
	},
	"2": {
		viewport = $HBoxContainer/SubViewportContainer2/SubViewport,
		camera = $HBoxContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $HBoxContainer/SubViewportContainer/SubViewport/Node/Player2
	}
}

func _ready():
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transorm := RemoteTransform2D.new()
		remote_transorm.remote_path = node.camera.get_path()
		node.player.add_child(remote_transorm)

func _process(_delta):
	if Input.is_action_pressed("time_skip"):	
		print("Time skipped!")
		next_play_section = true
