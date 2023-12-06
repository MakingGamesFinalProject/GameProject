extends Node2D

signal loading_screen_instantiated

# Referencing the two UI overlays
@onready var resources = $"../Game/UICollective/MarginContainer"
@onready var tasks = $"../Game/UICollective/CurrentTaskUI"

# Let's only emit the signal once
var signal_emitted := false

func _ready():
	resources.hide()
	tasks.hide()

func _process(_delta):
	if not signal_emitted:
		emit_signal("loading_screen_instantiated")

		signal_emitted = true

func map_generated() -> void:
	# Since the map generation is close to instant, here's an artificial delay
	await(get_tree().create_timer(1.0).timeout)

	resources.show()
	tasks.show()

	queue_free()
