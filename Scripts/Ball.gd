extends RigidBody2D
# https://forum.godotengine.org/t/how-to-stop-and-reset-rigidbody2d/5930


var reset_position
var is_reset_to_new = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

		pass



func reset_status(new_position):
	reset_position = new_position
	is_reset_to_new = true


func _integrate_forces(state):
	if is_reset_to_new:
		is_reset_to_new = false
		
		# Stop all movement
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.transform.origin = reset_position
		
		# Make the ball static  and disable collision after the current frame's physics step
		# make_static_deferred()


func _on_disappear_timer_timeout():
	#queue_free()
	pass # Replace with function body.
