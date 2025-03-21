extends CharacterBody3D

# Basic character movement.

@export var camera: Node3D

const SPEED = 6.0
const ACCELERATION = 1.0
const DECELERATION = 2.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_direction = Vector2()
var move_direction = Vector3()


func _physics_process(delta):
	# Get move input and direction
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_direction = (camera.global_transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump y
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movement x z
	if move_direction:
		velocity.x = move_toward(velocity.x, move_direction.x * SPEED * input_direction.length(), ACCELERATION)
		velocity.z = move_toward(velocity.z, move_direction.z * SPEED * input_direction.length(), ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()
