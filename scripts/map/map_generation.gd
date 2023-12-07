extends Node2D

# Preloading the foliage scenes
var grass_scene = preload("res://scenes/foliage/grass.tscn")
var bush_scene = preload("res://scenes/foliage/bush.tscn")
var tree_scene = preload("res://scenes/foliage/tree.tscn")

# Preloading the NPC
var npc_scene = preload("res://scenes/buildings/npc.tscn")

# Preloading the builings scenes
var water_filter_scene = preload("res://scenes/buildings/water_filter.tscn")
var workbench_scene = preload("res://scenes/buildings/recycling_workshop.tscn")
var wind_turbine_scene = preload("res://scenes/buildings/wind_turbine.tscn")
var house_scene = preload("res://scenes/buildings/shed.tscn")
var trash_collector_scene = preload("res://scenes/buildings/trash_collector.tscn")
var hamster_wheel_scene = preload("res://scenes/buildings/hamster_wheel.tscn")
var well_scene = preload("res://scenes/buildings/well.tscn")
var windmill_scene = preload("res://scenes/buildings/windmill.tscn")

# Preloading the scraps scene
var scraps_scene = preload("res://scenes/buildings/scrap_heap.tscn")

# Preloading the exit arch
var exit_arch_scene = preload("res://scenes/buildings/exit_arc.tscn")

# Density of all foliage can be set here
const GRASS_DENSITY := 1000
const BUSH_DENSITY := 50
const TREE_DENSITY := 25
const FOREST_TREE_DENSITY := 50

# Distribution of grass variants in percentages
const GRASS_DISTRIBUTION := [5, 20, 75] # [long, medium, short]

# Fixed positions of our buildings to randomly choose between
const WATER_FILTER_POSITIONS := [ \
	Vector2(-1414, 400), Vector2(-1902, 600), Vector2(-2333, 907), \
	Vector2(-2771, 1241), Vector2(-901, 250), \
	Vector2(143, -151), Vector2(602, -335), Vector2(1032, -586), \
	Vector2(1454, -939), Vector2(1804, -1341), Vector2(2239, -1494), \
	Vector2(2666, -1670), Vector2(3171, -1841)]

const WATER_FILTER_POSITION_OFFSET := Vector2(0, 167)

var starting_building_positions := [ \
	Vector2(-631, 1696), Vector2(2802, 918), Vector2(-2868, 366), \
	Vector2(1131, -1639), Vector2(-1194, -934), \
	Vector2(304, 1994), Vector2(1964, 732), \
	Vector2(3117, 54), Vector2(106, -771), Vector2(-2482, -756), \
	Vector2(-1586, 2360), Vector2(1103, 878), Vector2(-1785, 83), \
	Vector2(2138, -1926), Vector2(-717, -1815)]

var remaining_building_positions := [ \
	Vector2(-631, 1696), Vector2(2802, 918), Vector2(-2868, 366), \
	Vector2(1131, -1639), Vector2(-1194, -934), \
	Vector2(304, 1994), Vector2(1964, 732), \
	Vector2(3117, 54), Vector2(106, -771), Vector2(-2482, -756), \
	Vector2(-1586, 2360), Vector2(1103, 878), Vector2(-1785, 83), \
	Vector2(2138, -1926), Vector2(-717, -1815)]

var rng = RandomNumberGenerator.new()

# These are exhaustive lists of foliage in the level
var foliage : Array[Node2D] = []
var forest_trees : Array[StaticBody2D] = []

# Keep track of the number of grass, bush and initial tree instances
var grass_count := 0
var bushes_count := 0
var trees_count := 0

# Keep track of the NPC
var npc : StaticBody2D

# Keep track of the buildings
var water_filter : StaticBody2D
var workbench : StaticBody2D
var wind_turbine : StaticBody2D
var house : StaticBody2D
var trash_collector : StaticBody2D
var hamster_wheel : StaticBody2D
var well : StaticBody2D
var windmill : StaticBody2D
var buildings : Array[StaticBody2D] = []

# Keep track of all the scraps
var scraps : Array[StaticBody2D] = []

# Keep track of the exit arch
var exit_arch : StaticBody2D

# The function clears the map by freeing all instances and clearing lists
func clear_map() -> void:
	# First, all foliage that is not forest trees is removed
	for foliage_instance in foliage:
		foliage_instance.queue_free()
	foliage.clear()
	# Second, forest trees are removed
	for forest_tree_instance in forest_trees:
		forest_tree_instance.queue_free()
	forest_trees.clear()

	# Now, all buildings are removed
	if not !water_filter: # Not null check
		water_filter.queue_free()
	if not !workbench:
		workbench.queue_free()
	if not !wind_turbine:
		wind_turbine.queue_free()
	if not !house:
		house.queue_free()
	if not !trash_collector:
		trash_collector.queue_free()
	if not !hamster_wheel:
		hamster_wheel.queue_free()
	if not !well:
		well.queue_free()
	if not !windmill:
		windmill.queue_free()

	buildings.clear()
	remaining_building_positions = starting_building_positions

	# Then, all remaining scraps are removed
	for scraps_instance in scraps:
		if not !scraps_instance:
			scraps_instance.queue_free()
	scraps.clear()

	exit_arch.queue_free()

	# Finally, the NPC is removed
	npc.queue_free()

# The function generates grass and adds it to foliage
func generate_grass(world_size : Vector2) -> void:
	for i in range(GRASS_DENSITY):
		var grass_instance = grass_scene.instantiate() as Node2D

		# Randomly pick a variant of grass to spawn
		var tmp = rng.randi_range(1, 100)
		if tmp <= GRASS_DISTRIBUTION[0]:
			grass_instance.variant = 0
		elif tmp <= GRASS_DISTRIBUTION[1]:
			grass_instance.variant = 1
		else:
			grass_instance.variant = 2
		# Randomly place the grass instance somewhere within the world
		grass_instance.global_position = Vector2(rng.randi_range( \
			int(float(-world_size.x) / 2.0), int(float(world_size.x) / 2.0)), rng.randi_range( \
			int(float(-world_size.y) / 2.0), int(float(world_size.y) / 2.0)))

		foliage.append(grass_instance)

	# Remember the initial amount of grass instances
	grass_count = GRASS_DENSITY

# The function generates bushes and adds them to foliage
func generate_bushes(world_size : Vector2) -> void:
	for i in range(BUSH_DENSITY):
		var bush_instance = bush_scene.instantiate() as StaticBody2D

		# Randomly pick one of 5 variants of bush to spawn
		bush_instance.variant = rng.randi_range(0, 4)
		# Randomly place the bush instance somewhere within the world
		bush_instance.global_position = Vector2(rng.randi_range( \
			int(float(-world_size.x) / 2.0), int(float(world_size.x) / 2.0)), rng.randi_range( \
			int(float(-world_size.y) / 2.0), int(float(world_size.y) / 2.0)))

		foliage.append(bush_instance)

	# Remember the initial amount of bush instances
	bushes_count = BUSH_DENSITY

# The function generates trees and adds them to foliage
func generate_trees(world_size : Vector2) -> void:
	for i in range(TREE_DENSITY):
		var tree_instance = tree_scene.instantiate() as StaticBody2D

		# Randomly pick one of 5 variants of tree to spawn
		tree_instance.variant = rng.randi_range(0, 4)
		# Randomly place the tree instance somewhere within the world
		tree_instance.global_position = Vector2(rng.randi_range( \
			int(float(-world_size.x) / 2.0), int(float(world_size.x) / 2.0)), rng.randi_range( \
			int(float(-world_size.y) / 2.0), int(float(world_size.y) / 2.0)))

		foliage.append(tree_instance)

	# Remember the initial amount of tree instances
	trees_count = TREE_DENSITY

# The function generates two forests and adds the trees to foliage
func generate_forest_trees(world_size : Vector2) -> void:
	# Determine the, world relative, origin and size of the forests
	var sizes := [Vector2(world_size.x * 0.33, world_size.y * 0.33), \
		Vector2(world_size.x * 0.33, world_size.y * 0.33)] # [top-left, bottom-right]
	var origins := [Vector2(-world_size.x / 2 + sizes[0].x * 0.25, -world_size.y / 2 + sizes[0].y * 0.25), \
		Vector2(world_size.x / 2 - sizes[1].x * 0.25, world_size.y / 2 - sizes[0].y * -0.25)]

	for i in range(FOREST_TREE_DENSITY):
		var tree_instance = tree_scene.instantiate() as StaticBody2D
		var tree_instance2 = tree_scene.instantiate() as StaticBody2D

		# Randomly pick one of 5 variants of tree to spawn
		tree_instance.variant = rng.randi_range(0, 4)
		tree_instance2.variant = rng.randi_range(0, 4)
		# Randomly place the tree instance somewhere within the world
		tree_instance.global_position = Vector2(rng.randi_range( \
			origins[0].x - sizes[0].x / 2, origins[0].x + sizes[0].x / 2), rng.randi_range( \
			origins[0].y - sizes[0].y / 2, origins[0].y + sizes[0].y / 2))
		tree_instance2.global_position = Vector2(rng.randi_range( \
			origins[1].x - sizes[1].x / 2, origins[1].x + sizes[1].x / 2), rng.randi_range( \
			origins[1].y - sizes[1].y / 2, origins[1].y + sizes[1].y / 2))

		# Since forest trees are handled separately, the group of the trees are changed
		tree_instance.remove_from_group("Tree")
		tree_instance.add_to_group("Forest Tree")
		tree_instance2.remove_from_group("Tree")
		tree_instance2.add_to_group("Forest Tree")

		forest_trees.append(tree_instance)
		forest_trees.append(tree_instance2)

# The function deletes unwated grass
func delete_grass() -> void:
	# Temporary list of deleted grass is necessary
	var deleted_grass : Array[Node2D] = []

	for i in range(grass_count):
		if not deleted_grass.has(foliage[i]): # Check if itself is up for deletion
			for detected_grass in foliage[i].detected_grass:
				if not deleted_grass.has(detected_grass): # No grass is deleted more than once
					deleted_grass.append(detected_grass)

	# Delete grass from foliage
	for grass_instance in deleted_grass:
		foliage.erase(grass_instance)
		grass_instance.queue_free()

		# Update the amount of grass instances
		grass_count -= 1

# The function deletes unwated bushes
func delete_bushes() -> void:
	# Temporary list of deleted bushes is necessary
	var deleted_bushes : Array[StaticBody2D] = []

	for i in range(grass_count, grass_count + bushes_count):
		if not deleted_bushes.has(foliage[i]): # Check if itself is up for deletion
			for detected_bush in foliage[i].detected_bushes:
				if not deleted_bushes.has(detected_bush): # No bush is deleted more than once
					deleted_bushes.append(detected_bush)

	# Delete bushes from foliage
	for bush_instance in deleted_bushes:
		foliage.erase(bush_instance)
		bush_instance.queue_free()

		# Update the amount of bush instances
		bushes_count -= 1

# The function deletes unwated trees
func delete_trees() -> void:
	# Temporary list of deleted trees is necessary
	var deleted_trees : Array[StaticBody2D] = []

	for i in range(grass_count + bushes_count, foliage.size() - 1):
		if not deleted_trees.has(foliage[i]): # Check if itself is up for deletion
			for detected_tree in foliage[i].detected_trees:
				if not deleted_trees.has(detected_tree): # No tree is deleted more than once
					deleted_trees.append(detected_tree)

	# Delete trees from foliage
	for tree_instance in deleted_trees:
		foliage.erase(tree_instance)
		tree_instance.queue_free()

		# Update the amount of tree instances
		trees_count -= 1

# The function deletes unwated forest trees
func delete_forest_trees() -> void:
	# Temporary list of deleted trees is necessary
	var deleted_forest_trees : Array[StaticBody2D] = []

	for i in range(forest_trees.size()):
		if not deleted_forest_trees.has(forest_trees[i]): # Check if itself is up for deletion
			for detected_forest_tree in forest_trees[i].detected_forest_trees:
				if not deleted_forest_trees.has(detected_forest_tree): # No forest tree is deleted more than once
					deleted_forest_trees.append(detected_forest_tree)

	# Delete forest trees from list of forest trees
	for forest_tree_instance in deleted_forest_trees:
		forest_trees.erase(forest_tree_instance)
		forest_tree_instance.queue_free()

# The function generates a specific NPC
func generate_npc(npc_name : String) -> void:
	npc = npc_scene.instantiate() as StaticBody2D
	npc.what_npc_am_i = npc_name
	npc.global_position = Vector2(-271, 2573)

# The function create one of each remaining building to be generated
func generate_buildings(buildings_to_generate : Array[String]) -> void:
	if buildings_to_generate.has("Water Filter"):
		water_filter = water_filter_scene.instantiate() as StaticBody2D
		water_filter.global_position = WATER_FILTER_POSITIONS[rng.randi_range(0, 12)] + WATER_FILTER_POSITION_OFFSET
		buildings.append(water_filter)

	if buildings_to_generate.has("Shed"):
		house = house_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		house.global_position = random_position
		buildings.append(house)
	
	if buildings_to_generate.has("Wind Turbine"):
		wind_turbine = wind_turbine_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		wind_turbine.global_position = random_position
		buildings.append(wind_turbine)
	
	if buildings_to_generate.has("Recycling Workshop"):
		workbench = workbench_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		workbench.global_position = random_position
		buildings.append(workbench)

	if buildings_to_generate.has("Trash Collector"):
		trash_collector = trash_collector_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		buildings.append(trash_collector)

	if buildings_to_generate.has("Well"):
		well = well_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		well.global_position = random_position
		buildings.append(well)
	
	if buildings_to_generate.has("Hamster Wheel"):
		hamster_wheel = hamster_wheel_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		hamster_wheel.global_position = random_position
		buildings.append(hamster_wheel)
	
	if buildings_to_generate.has("Windmill"):
		windmill = windmill_scene.instantiate() as StaticBody2D
		var random_position = remaining_building_positions.pick_random()
		remaining_building_positions.erase(random_position)
		windmill.global_position = random_position
		buildings.append(windmill)

# To improve visual clarity, clean up foliage around all the buildings
func clear_buildings_areas(buildings_to_generate : Array[String]) -> void:
	if buildings_to_generate.has("underground water filter"):
		for detected_foliage in water_filter.detected_foliage:
			foliage.erase(detected_foliage)
			detected_foliage.queue_free()

	if buildings_to_generate.has("shed"):
		for detected_foliage in house.detected_foliage:
			foliage.erase(detected_foliage)
			detected_foliage.queue_free()

	if buildings_to_generate.has("wind_turbine"):
		for detected_foliage in wind_turbine.detected_foliage:
			foliage.erase(detected_foliage)
			detected_foliage.queue_free()

	if buildings_to_generate.has("recycling workshop"):
		for detected_foliage in workbench.detected_foliage:
			foliage.erase(detected_foliage)
			detected_foliage.queue_free()	

# The function generates a bunch of scraps with random positions in the world
func generate_scraps(world_size : Vector2) -> void:
	for i in range(250):
		var scraps_instance = scraps_scene.instantiate() as StaticBody2D

		scraps_instance.global_position = Vector2(rng.randi_range( \
			int(float(-world_size.x) / 2.0), int(float(world_size.x) / 2.0)), rng.randi_range( \
			int(float(-world_size.y) / 2.0), int(float(world_size.y) / 2.0)))

		scraps.append(scraps_instance)

# The function deletes scraps placed badly in the world and picks 5 of the remaining
func pick_scraps() -> void:
	# Temporary list of deleted scraps is necessary
	var deleted_scraps : Array[StaticBody2D] = []

	# Remove scraps on top of or too close to eachother
	# and those obstructed by world obstacles, buildings and forest
	for scraps_instance in scraps:
		if not deleted_scraps.has(scraps_instance): # Check if itself is up for deletion
			if scraps_instance.is_obstructed:
				deleted_scraps.append(scraps_instance)
			else:
				for detected_scraps in scraps_instance.detected_scraps:
					if not deleted_scraps.has(detected_scraps): # No scraps is deleted more than once
						deleted_scraps.append(detected_scraps)

	# Erase and free marked scraps
	for scraps_instance in deleted_scraps:
		scraps.erase(scraps_instance)
		scraps_instance.queue_free()

	# Pick 5 of the remaining scraps
	for i in range(5, scraps.size()):
		deleted_scraps.append(scraps[i])
	for scraps_instance in deleted_scraps:
		scraps.erase(scraps_instance)
		scraps_instance.queue_free()

	# Remove foliage around the scraps to improve visual clarity
	for scraps_instance in scraps:
		for detected_foliage in scraps_instance.detected_foliage:
			foliage.erase(detected_foliage)
			detected_foliage.queue_free()

# The function generates the exit arch
func generate_exit_arch() -> void:
	exit_arch = exit_arch_scene.instantiate() as StaticBody2D
