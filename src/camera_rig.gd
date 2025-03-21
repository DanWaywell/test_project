extends Node3D
class_name CameraRig
# Basic 3rd person camera rig with over the sholder aiming.

@export var target_object: Node3D
@export var can_aim = true
@export var mouse_sens_normal = 0.1
@export var mouse_sens_aimed = 0.1
@export var stick_sens_normal = 4.0
@export var stick_sens_aimed = 3.0
@export var distance_normal = 3.0
@export var distance_aimed = 1.0
@export var spring_offset_normal = Vector3(0.0, 0.0, 0.0)
@export var spring_offset_aimed = Vector3(1.0, 0.3, 0.0)
@export var fov_normal = 90
@export var fov_aimed = 60


var mouse_sensitivity = mouse_sens_normal
var stick_sensitivety = stick_sens_normal
var distance = distance_normal
var spring_offset = spring_offset_normal
var mouse_input = Vector2()
var aiming = false
var sholder_side = "right"

@onready var spring = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring.spring_length = distance
	camera.fov = fov_normal
	
	if target_object:
		set_as_top_level(true)
		

func _input(event):
	# Get mouse input
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_input.x += -event.relative.x * mouse_sensitivity
		mouse_input.y += -event.relative.y * mouse_sensitivity


func _physics_process(delta):
	if target_object:
		global_transform.origin = target_object.global_transform.origin
	# Get stick input
	var stick_input = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	
	# Use stick or mouse input
	var movement
	if mouse_input:
		movement = mouse_input
		mouse_input = Vector2.ZERO
	else:
		movement = stick_input
	
	# Apply movement to rotations and clamp the x
	rotate_y(movement.x * stick_sensitivety * delta)
	spring.rotate_x(movement.y * stick_sensitivety * delta)
	spring.rotation.x = clamp(spring.rotation.x, -1.5, 1.5)
	
	
	# Aiming
	# Switch camera sholder
#	if Input.is_action_just_pressed("switch_camera_side"):
#		switch_sholder()
		
	if can_aim:
		# Aim in or out
		if Input.is_action_pressed("aim"):
			aim_in()
		else:
			aim_out()


#func switch_sholder():
#	if sholder_side == "right":
#		sholder_side = "left"
#		var tween = create_tween()
#		tween.tween_property(spring, "position", Vector3(-x_offset, 0, 0), 0.1)
#	else:
#		sholder_side = "right"
#		var tween = create_tween()
#		tween.tween_property(spring, "position", Vector3(x_offset, 0, 0), 0.1)


func aim_in():
	if not aiming:
		aiming = true
		stick_sensitivety = stick_sens_aimed
		mouse_sensitivity = mouse_sens_aimed
		spring_offset = spring_offset_aimed

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(spring, "spring_length", distance_aimed, 0.08)
		tween.tween_property(camera, "fov", fov_aimed, 0.05)
		tween.tween_property(spring, "position", spring_offset, 0.08)

#		if sholder_side == "right":
#			spring.position = spring_offset
#		else:
#			spring.position = -spring_offset


func aim_out():
	if aiming:
		aiming = false
		stick_sensitivety = stick_sens_normal
		mouse_sensitivity = mouse_sens_normal
		spring_offset = spring_offset_normal

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(spring, "spring_length", distance_normal, 0.08)
		tween.tween_property(camera, "fov", fov_normal, 0.05)
		tween.tween_property(spring, "position", spring_offset, 0.08)

#		if sholder_side == "right":
#			spring.position = spring_offset
#		else:
#			spring.position = -spring_offset
