extends Node2D

@export var ball: PackedScene

var ball_spawn_location
var balls_list

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_spawn_location = $Balls/BallSpawner/BallSpawnerLocation
	balls_list = $Balls
	_on_ball_timer_timeout()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_timer_timeout():
	var _ball = ball.instantiate()
	
	balls_list.add_child(_ball)
	ball_spawn_location.progress_ratio  = randf()
	_ball.global_position = ball_spawn_location.global_position
	#print("spawn ball at ", _ball.position)
	pass # Replace with function body.


func _on_play_pressed():
	#LevelManager.changeScene("")
	pass # Replace with function body.
