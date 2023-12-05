extends Node


# Path to JSON notification file
var notification_path = "res://data/notification.json"

# The loaded JSON file
var notifications := []

# displaying dialog variables
var visible = false
var current_id = -1

# headshot folder path
var headshot_path = "res://art/World/Player Map/NPCs/headshots/"

# notification fields
@onready var notification : TextureRect = $dialog_popup
@onready var headshot : TextureRect = $dialog_popup/HBoxContainer/Control/headshot
@onready var notification_name : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control/name
@onready var notification_title : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control2/title
@onready var notification_text : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control3/dialog

func _ready():	
	# Don't show the pop-up right away
	notification.visible = visible
	
	get_json()
	
func get_json():
	# Get JSON data and save in a variable
	var file = FileAccess.open(notification_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var notifications_data = json.data["notifications"]
		if typeof(notifications_data) == TYPE_ARRAY:
			notifications = notifications_data
			# print(notifications) # Prints array
		else:
			print("Unexpected data in notifications")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())


# Call once to show, call again to hide
func show_dialog(dialog_id: int):
	# Put in correct info in the notification
	# make the notification visible
	
	if not self.is_node_ready():
		_ready()
	get_json()
	
	for dialog in notifications:
		if int ( dialog["id"] ) == dialog_id:
			# load the headshot
			var loaded_texture = load(headshot_path + dialog["picture_file"])
			headshot.texture = loaded_texture
			
			# insert text
			notification_name.text = dialog["name"]
			notification_title.text = dialog["title"]
			notification_text.text = dialog["text"]
			
			# set variables
			visible = true
			notification.visible = visible
			current_id = int( dialog_id )
	
func hide_dialog():
	# if the state of the notification is visible then make it invisible and reset the current_id variable
	if visible == true:
		visible = false
		notification.visible = visible
		current_id = -1
		return # exit the function
	
