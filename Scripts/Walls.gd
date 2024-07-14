extends Node2D

@export_category("Rotate")
@export var is_rotate = false
@export_enum("Right:1", "Left:-1") var rotate_direction = 1
@export var rotate_speed = 1
@export_category("Moving")
@export var is_moving = false
@export var move_from = Vector2(0,0)
@export var move_to = Vector2(0,0)
@export var move_speed = 5
@export var test = false

func _process(delta):
	if is_rotate:
		rotate(delta * rotate_speed * rotate_direction)
	
	pass
