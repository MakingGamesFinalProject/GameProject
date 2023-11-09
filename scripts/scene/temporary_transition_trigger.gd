extends Area2D

# This script is an example of how to "change scene"
func _on_body_entered(body):
	SceneManager.change_scene(body, self)
