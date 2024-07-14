extends Node2D

var current_level = 1
var in_game_menu

const MAIN_MENU = "res://Scenes/MainMenu.tscn"

var level_list

const SCENES_PATH = "res://Scenes/Levels/"
const SCENE_LIST = ["res://Scenes/MainMenu.tscn"] # 0 is main menu, 1 is level 1, etc...
var current_level_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#current_level = $"Levels/Level 1"
	level_list = $Levels
	_get_levels_list()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_levels_list():
	dir_contents("res://Scenes/Levels/")
	pass

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: ", SCENES_PATH + file_name)
			else:
				print("Found file: ", SCENES_PATH + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func changeScene(scene_id):
	print("change to mm")
	for i in level_list.get_children():
		i.queue_free()
	var _scene = load(SCENE_LIST[scene_id])
	level_list.add_child(_scene.instantiate())
	pass
