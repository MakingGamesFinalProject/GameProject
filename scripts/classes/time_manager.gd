extends Node

class_name WaitUtil

func _ready():
	pass

static func wait(seconds: float, callback_obj: Object, callback_func: String) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	callback_obj.add_child(timer)
	timer.connect("timeout", Callable(callback_obj, callback_func))
	timer.start()
