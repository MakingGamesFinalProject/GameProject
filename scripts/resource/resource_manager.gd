extends Node

# Declaration and initialization of our three resources
var water : int = 0
var energy : int = 0
var scraps : int = 0
var can_play_water_sound = true
var can_play_scrap_sound = true
@export var time_to_wait_to_play_next_sound_in_seconds = 2

func increase_water(amount):
	play_water_pickup_sound()
	water = clamp(water + amount, 0, 999)

func increase_energy(amount):
	energy = clamp(energy + amount, 0, 999)

func increase_scraps(amount):
	play_scrap_pickup_sound()
	scraps = clamp(scraps + amount, 0, 999)

func decrease_water(amount):
	water = clamp(water - amount, 0, 999)

func decrease_energy(amount):
	energy = clamp(energy - amount, 0, 999)

func decrease_scraps(amount):
	scraps = clamp(scraps - amount, 0, 999)

func reset_resources():
	water = 0
	energy = 0
	scraps = 0

func play_water_pickup_sound():
	if !$WaterPickUpSound.is_playing():
		$WaterPickUpSound.play()
		var time_manager = WaitUtil.new()
		can_play_water_sound = false
		time_manager.wait(time_to_wait_to_play_next_sound_in_seconds, self, "_reset_can_play_sound_after_timeout_water")

func play_scrap_pickup_sound():
	if !$ScrapsPickUpSound.is_playing():
		$ScrapsPickUpSound.play()
		var time_manager = WaitUtil.new()
		can_play_scrap_sound = false
		time_manager.wait(time_to_wait_to_play_next_sound_in_seconds, self, "_reset_can_play_sound_after_timeout_scrap")

func _reset_can_play_sound_after_timeout_water():
	can_play_water_sound = true

func _reset_can_play_sound_after_timeout_scrap():
	can_play_scrap_sound = true
