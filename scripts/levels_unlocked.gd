extends Node


#var levelsUnlocked: Array = ["Level1Button"];

var levelsUnlocked: Array = ["Level1Button","Level2Button","Level3Button","Level4Button","Level5Button",
"Level6Button","Level7Button","Level8Button","Level9Button","Level10Button","Level11Button","Level12Button","Level13Button","Level14Button"
,"Level15Button"];

func get_array():
	return levelsUnlocked;

func make_level_available(level_name):
	levelsUnlocked.append(level_name)
	print(level_name+" shalom");
