extends Node2D

signal screen_darkened

const FADE_IN_TIME = 0.25
const FADE_OUT_TIME = 0.25
const FADE_DELAY = 0.5

func _ready():
	var fade_out = create_tween()
	fade_out.tween_property(self, "modulate", Color(1, 1, 1, 1), FADE_IN_TIME).from(Color(1, 1, 1, 0))
	await(fade_out.finished)
	emit_signal("screen_darkened")

	var fade_delay = Timer.new()
	fade_delay.wait_time = FADE_DELAY
	fade_delay.autostart = false
	fade_delay.one_shot = true
	get_tree().root.add_child(fade_delay)
	fade_delay.start()
	await(fade_delay.timeout)
	fade_delay.queue_free()

	var fade_in = create_tween()
	fade_in.tween_property(self, "modulate", Color(1, 1, 1, 0), FADE_OUT_TIME)
	await(fade_in.finished)

	queue_free()
