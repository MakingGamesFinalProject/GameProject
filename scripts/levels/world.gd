extends Node2D

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

# Below is a list of booleans making sure buildings are only generated once
var water_filter_generated := false
var water_filter_area_cleared := false
var buildings_generated := false
var buildings_areas_cleared := false

# Keep track if scraps are generated
var scraps_generated := false
var scraps_picked := false

func _process(_delta):
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

	# Clear out an area around the Water Filter designated spot
	if water_filter_generated and not water_filter_area_cleared:
		MapGeneration.clear_water_filter_area()
		water_filter_area_cleared = true

	# Generate the Water Filter and add it to the world
	if not water_filter_generated:
		add_child(MapGeneration.generate_water_filter())
		water_filter_generated = true

	# Clear out an area around the Water Filter designated spot
	if buildings_generated and not buildings_areas_cleared:
		MapGeneration.clear_buildings_areas()
		buildings_areas_cleared = true

	# Generate all other buildings and add them to the world
	if not buildings_generated:
		MapGeneration.generate_buildings()
		add_child(MapGeneration.workbench)
		add_child(MapGeneration.house)
		add_child(MapGeneration.wind_turbine)

		buildings_generated = true

	# Generate 5 scraps and add them to the world
	if scraps_generated and not scraps_picked:
		MapGeneration.pick_scraps()
		scraps_picked = true

	if not scraps_generated:
		MapGeneration.generate_scraps(world_size)
		for scraps in MapGeneration.scraps:
			add_child(scraps)

		scraps_generated = true

# The world has areas in which we don't want foliage
# Those areas can be changed by modifying the polygon collider
func detect_foliage(area) -> void:
	var parent = area.get_parent()

	if parent.is_in_group("Grass") or parent.is_in_group("Bush") or parent.is_in_group("Tree"):
		detected_foliage.append(parent)
