extends Node2D

# The following signal will be emitted when the screen is fully black
signal screen_darkened

# Timings for the fade effect
const FADE_IN_TIME : float = 0.25
const FADE_OUT_TIME : float = 0.25
const FADE_DELAY : float = 0.5

func _ready():
	# fade_out tween is responsible for the initial fade to black and emits the signal
	var fade_out = create_tween()
	fade_out.tween_property(self, "modulate", Color(1, 1, 1, 1), FADE_IN_TIME) \
		.from(Color(1, 1, 1, 0))
	await(fade_out.finished)
	emit_signal("screen_darkened")

	# A delay ensures that the play can be repositioned without showing it
	var fade_delay = Timer.new()
	fade_delay.wait_time = FADE_DELAY
	fade_delay.autostart = false
	fade_delay.one_shot = true
	get_tree().root.add_child(fade_delay)
	fade_delay.start()
	await(fade_delay.timeout)
	fade_delay.queue_free()

	# Finally, the fade in shows the game again
	var fade_in = create_tween()
	fade_in.tween_property(self, "modulate", Color(1, 1, 1, 0), FADE_OUT_TIME)
	await(fade_in.finished)

	queue_free()
