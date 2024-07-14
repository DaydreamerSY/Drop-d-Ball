extends Node2D

var in_game_menu

const MAIN_MENU = "res://Scenes/MainMenu.tscn"

var level_list

const SCENES_PATH = "res://Scenes/Levels/"
var SCENE_LIST = ["res://Scenes/MainMenu.tscn"] # 0 is main menu, 1 is level 1, etc...
var current_level_id = 1 # will continue at this lavel, can read-write from file

var is_at_main_menu = true # for animation in main menu not accident go to levels

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
				SCENE_LIST.append(SCENES_PATH + file_name.trim_suffix('.remap'))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func changeScene(scene_id):
	print("List levels available: ", SCENE_LIST)
	for i in level_list.get_children():
		i.queue_free()
	current_level_id = scene_id
	if scene_id == 0:
		LevelManager.is_at_main_menu = true
	var _scene = load(SCENE_LIST[scene_id])
	level_list.call_deferred("add_child", _scene.instantiate())
	pass

func nextLevel():
	if current_level_id == len(SCENE_LIST) - 1:
		changeScene(0)
	else:
		changeScene(current_level_id+1)
	

func continue_game_progress():
	changeScene(current_level_id)
