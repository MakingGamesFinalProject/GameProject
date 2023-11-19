extends Node


# Path to JSON notification file
var notification_path = "res://data/notification.json"

# The loaded JSON file
var notifications := []

#displaying dialog variables
var visible = false
var current_id = -1

# notification fields
@onready var headshot : TextureRect = $dialog_popup/HBoxContainer/Control/headshot
@onready var notification_name : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control/name
@onready var title : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control2/title
@onready var dialog : Label = $dialog_popup/HBoxContainer/Control2/VBoxContainer/Control3/dialog

func _ready():	
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
			print(notifications) # Prints array
		else:
			print("Unexpected data in notifications")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func show_dialog(dialog_id: int):
	
	# if the state of the notification is visible then make it invisible and reset the current_id variable
	if visible == true:
		visible = false
		current_id = -1
		return # exit the function
	
	
	# Put in correct info in the notification
	
	
	
	# make the notification visible
	pass
