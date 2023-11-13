extends Node

# Declaration and initialization of our three resources
var water : int = 0
var energy : int = 0
var scraps : int = 0

func increase_water(amount):
	water = clamp(water + amount, 0, 999)

func increase_energy(amount):
	energy = clamp(energy + amount, 0, 999)

func increase_scraps(amount):
	scraps = clamp(scraps + amount, 0, 999)

func decrease_water(amount):
	water = clamp(water - amount, 0, 999)

func decrease_energy(amount):
	energy = clamp(energy - amount, 0, 999)

func decrease_scraps(amount):
	scraps = clamp(scraps - amount, 0, 999)
