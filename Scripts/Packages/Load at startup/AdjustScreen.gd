extends Node


func _ready():
	var width: int
	var height: int
	
	print(OS.get_name())

	if OS.get_name() == "Windows":
		width = 540
		height = 960
		DisplayServer.window_set_position(DisplayServer.window_get_position() - Vector2i(150, 150))
	elif OS.get_name() == "macOS":
		width = 1080
		height = 1920
	else:
		width = 1080 # Default width for other OS
		height = 2520 # Default height for other OS

	DisplayServer.window_set_size(Vector2(width, height))

