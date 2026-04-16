extends CharacterBody3D

#movements vars ----------------------------------------------------------------
const walking_speed = 10.0
const running_speed = 100.0
var SPEED = 0
var direction
const JUMP_VELOCITY = 4.5
@export var mouse_sensitivity := 0.002
var camera_x_rotation := 0.0
var mouse_paused = -1
#-------------------------------------------------------------------------------
#bob_jiggle vars
var bob_frq = 2 # how many bobs head do
var bob_amp = 0.08 # how much head go up and down
var t_bob = 0 # lenght of sine wave
#-------------------------------------------------------------------------------
var base_fov = 75.0
var fov_change = 1.5
#-------------------------------------------------------------------------------






func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _physics_process(delta: float) -> void:
	
	#gravity(delta)
	#jump()
	#moving(delta)
	#juice
	bob_jiggle(delta)
	fov_changer(delta)
	move_and_slide()




#func gravity(delta):
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
#func jump():
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
#func moving(delta):
	#if Input.is_action_pressed("running"):
		#SPEED = running_speed
	#else:
		#SPEED = walking_speed
#
	#var input_dir := Input.get_vector("left", "right", "forward", "backward")
	#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if is_on_floor():
		#if direction:
			#velocity.x = direction.x * SPEED
			#velocity.z = direction.z * SPEED
		#else:
			#velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0)
			#velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0)
	#else :
		#velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		#velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)



func _unhandled_input(event):
	#checking if mouse pause button has been pressed
	if Input.is_action_just_pressed("mouse_pause"):
		mouse_paused *= -1
	
	#if mousepause less that zero u can use mouse \ bigger than zero u cant use the mouse
	if mouse_paused < 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#camera rotations
	if mouse_paused < 0:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera_x_rotation -= event.relative.y * mouse_sensitivity
			camera_x_rotation = clamp(camera_x_rotation, deg_to_rad(-80), deg_to_rad(80))
			$head/Camera3D.rotation.x = camera_x_rotation


func bob_jiggle(delta):
	t_bob += delta * velocity.length() * float(is_on_floor())
	$head/Camera3D.transform.origin = _headbob(t_bob)
	
func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frq) * bob_amp
	pos.x = cos(time * bob_frq / 2) * bob_amp
	return pos
	


func fov_changer(delta):
	var velocity_clamper = clamp(velocity.length(), 0.5, running_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamper
	$head/Camera3D.fov = lerp($head/Camera3D.fov, target_fov, delta * 8.0)
