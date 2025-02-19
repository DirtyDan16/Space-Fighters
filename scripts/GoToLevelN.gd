extends Control

# Dictionary to map button names to level scenes
var level_scenes = {
	"Level1Button": "res://scenes/levels/level_1.tscn",
	"Level2Button": "res://scenes/levels/level_2.tscn",
	"Level3Button": "res://scenes/levels/level_3.tscn",
	"Level4Button": "res://scenes/levels/level_4.tscn",
	"Level5Button": "res://scenes/levels/level_5.tscn",
	"Level6Button": "res://scenes/levels/level_6.tscn",
	"Level7Button": "res://scenes/levels/level_7.tscn",
	"Level8Button": "res://scenes/levels/level_8.tscn",
	"Level9Button": "res://scenes/levels/level_9.tscn",
	"Level10Button": "res://scenes/levels/level_10.tscn",
	"Level11Button": "res://scenes/levels/level_11.tscn"
}

@onready var message = $LevelsUnlockedMessage
@onready var all_buttons = %AllButtons

func _ready():
	message.visible = false # If somehow this message is shown
	# Connect all button pressed signals to the _on_button_pressed function
	for button_name in level_scenes.keys():
		var button = all_buttons.get_node(button_name)
		if button:
			# Check if the signal is already connected
			if not button.is_connected("pressed", Callable(self, "_on_button_pressed").bind(button_name)):
				button.pressed.connect(Callable(self, "_on_button_pressed").bind(button_name))
			else:
				print("Signal 'pressed' is already connected for button: " + button_name)
		else:
			print("Button not found: " + button_name)

func _on_button_pressed(button_name):
	var levelsUserCanAccess = LevelsUnlocked.get_array()
	# Get the corresponding level scene
	var level_scene = level_scenes[button_name]
	if level_scene != null:
		var new_scene = ResourceLoader.load(level_scene)
		if new_scene:
			if button_name in levelsUserCanAccess:
				# Change scene only if it is loaded and user has access
				get_tree().change_scene_to_file(level_scene)
			else:
				print("You haven't unlocked this level yet")
				message.visible = true
		else:
			print("Failed to load scene: " + level_scene)
	else:
		print("No level scene found for button: " + button_name)
