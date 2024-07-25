extends RigidBody2D
# https://forum.godotengine.org/t/how-to-stop-and-reset-rigidbody2d/5930


var reset_position
var is_reset_to_new = false

var particle : CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	particle = $CPUParticles2D
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
	# for features: map that do not allow stackup to win
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(2).timeout
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	print("Collide with ", body)
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	particle.emitting = true
	
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	#is_emiting_particle = false
	pass # Replace with function body.
