extends Node2D

# Preloading the loading screen
var loading_screen_scene = preload("res://scenes/ui/loading_screen.tscn")
var loading_screen : Node2D

# The path of the json file which keeps track of NPCs, their buildings and tasks
var json_path := "res://data/npc_building_task.json"

# The size and scale of the map sprite
const MAP_SIZE := Vector2(7049, 5423)
const MAP_SCALE := Vector2(1.0, 1.0)

# The actual size of the world is calculated
var world_size := Vector2(MAP_SIZE.x * MAP_SCALE.x, MAP_SIZE.y * MAP_SCALE.y)

# Since Area2D doesn't send signals from within the ready function,
# map generation is done in this hacky way within process.
# Below is a list of booleans making sure everything is run only once.
# This also illustrates the true order in which the map is generated.
var grass_generated := false
var grass_deleted := false
var bushes_generated := false
var bushes_deleted := false
var trees_generated := false
var trees_deleted := false
var forest_trees_generated := false
var forest_trees_deleted := false

var scene_populated := false

# The following is foliage which is not wanted in certain areas of the world
var detected_foliage : Array[Node2D] = []

var foliage_deleted := false

# Keep track if the NPC is generated
var npc_generated := false
var npc_present := "Huggy" # The current NPC in the world
var npc_buildings : Array[String] # The buildings associated with the NPC

# Below is a list of booleans making sure buildings are only generated once
var buildings_generated := false
var buildings_areas_cleared := false

# Keep track if scraps are generated
var scraps_generated := false
var scraps_picked := false

func _ready():
	# Instantiate the loading screen and add it to the main scene
	loading_screen = loading_screen_scene.instantiate() as Node2D
	get_tree().root.add_child.call_deferred(loading_screen)

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		# Instantiate the loading screen and add it to the main scene
		loading_screen = loading_screen_scene.instantiate() as Node2D
		get_tree().root.add_child(loading_screen)

		await(loading_screen.loading_screen_instantiated)

		regenerate()

	# Deleting grass which spawned on top of or close to another grass tuft
	if grass_generated and not grass_deleted:
		MapGeneration.delete_grass()
		grass_deleted = true

	# Deleting bushes which spawned on top of or close to another bush
	if bushes_generated and not bushes_deleted:
		MapGeneration.delete_bushes()
		bushes_deleted = true

	# Deleting trees which spawned on top of or close to another tree
	if trees_generated and not trees_deleted:
		MapGeneration.delete_trees()
		trees_deleted = true

	# Deleting forest trees which spawned on top of or close to another forest tree
	if forest_trees_generated and not forest_trees_deleted:
		MapGeneration.delete_forest_trees()
		forest_trees_deleted = true

	# Densities, variant distribution, positions etc. of grass can be changed in map_generation.gd
	if not grass_generated:
		MapGeneration.generate_grass(world_size)
		grass_generated = true

	# Densities, positions etc. of bushes can be changed within map_generation.gd
	if not bushes_generated:
		MapGeneration.generate_bushes(world_size)
		bushes_generated = true

	# Densities, positions etc. of trees can be changed within map_generation.gd
	if not trees_generated:
		MapGeneration.generate_trees(world_size)
		trees_generated = true

	# Densities, positions etc. of forests can be changed within map_generation.gd
	if not forest_trees_generated:
		MapGeneration.generate_forest_trees(world_size)
		forest_trees_generated = true

	# Show the foliage by adding it to the scene
	if not scene_populated:
		for foliage in MapGeneration.foliage: # Grass, bushes and initial trees
			add_child(foliage)
		for forest_tree in MapGeneration.forest_trees: # Forest trees are handled separately
			add_child(forest_tree)

		scene_populated = true

	# This is the final clean up of unwanted foliage
	if grass_deleted and bushes_deleted and trees_deleted and not foliage_deleted:
		for foliage in detected_foliage:
			MapGeneration.foliage.erase(foliage)
			foliage.queue_free()

		detected_foliage.clear()

		foliage_deleted = true

	# The position of the NPC can be set within map_generation.gd
	if not npc_generated:
		var npc_name = choose_random_npc()
		MapGeneration.generate_npc(npc_name)
		add_child(MapGeneration.npc)

		npc_generated = true
		npc_present = npc_name
		npc_buildings = get_json_buildings(get_json_text(json_path), npc_name)

	# Clear out an area around the Water Filter designated spot
	if buildings_generated and not buildings_areas_cleared:
		MapGeneration.clear_buildings_areas(npc_buildings)
		buildings_areas_cleared = true

	# Generate all other buildings and add them to the world
	if not buildings_generated:
		MapGeneration.generate_buildings(npc_buildings)
		for building in MapGeneration.buildings:
			add_child(building)

		buildings_generated = true

	# Generate 5 scraps and add them to the world
	if scraps_generated and not scraps_picked:
		MapGeneration.pick_scraps()
		scraps_picked = true

		loading_screen.map_generated()

	if not scraps_generated:
		MapGeneration.generate_scraps(world_size)
		for scraps in MapGeneration.scraps:
			add_child(scraps)

		scraps_generated = true

# Open the file, read the file, close the file
func get_json_text(path : String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	return json_text

# The function returns a list of NPCs
func get_json_npcs(text : String) -> Array[String]:
	var json = JSON.new()
	json.parse(text)
	var json_data = json.data["relationships"]

	var npcs : Array[String] = []
	for relationship in json_data:
		npcs.append(relationship["npc"])

	return npcs

func get_json_buildings(text : String, npc_name : String) -> Array[String]:
	var json = JSON.new()
	json.parse(text)
	var json_data = json.data["relationships"]

	var buildings : Array[String] = []
	for relationship in json_data:
		if relationship["npc"] == npc_name:
			for building in relationship["buildings"]:
				buildings.append(building)

	return buildings

# The function chooses a random NPC from the list of NPCs in the json
func choose_random_npc() -> String:
	var npcs : Array[String] = get_json_npcs(get_json_text(json_path))

	return npcs.pick_random()

# The world has areas in which we don't want foliage
# Those areas can be changed by modifying the polygon collider
func detect_foliage(area) -> void:
	var parent = area.get_parent()

	if parent.is_in_group("Grass") or parent.is_in_group("Bush") or parent.is_in_group("Tree"):
		detected_foliage.append(parent)

# The function clears the map of everything but the players, regenerates all foliage,
# adds a random NPC and spawns their associated buildings in the world
func regenerate() -> void:
	MapGeneration.clear_map()

	grass_generated = false
	grass_deleted = false
	bushes_generated = false
	bushes_deleted = false
	trees_generated = false
	trees_deleted = false
	forest_trees_generated = false
	forest_trees_deleted = false

	scene_populated = false

	foliage_deleted = false

	npc_generated = false

	buildings_generated = false
	buildings_areas_cleared = false

	scraps_generated = false
	scraps_picked = false
