extends Area2D

func _on_body_entered(body):
	SceneManager.change_scene(body, self)
