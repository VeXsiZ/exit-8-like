extends STATE

var gravity_force = -9.8
const walking_speed = 5.0
const running_speed = 12.0
var SPEED = 0
var direction
const JUMP_VELOCITY = 4.5


func enter():
	player_ref.velocity.y = JUMP_VELOCITY

func update():
	rules_checker()

func physics_update(delta):
	gravity(delta)
	jump()
	moving(delta)

func exite():
	pass


func rules_checker():
	if player_ref.is_on_floor():
		if ["forward","backward","left","right"].any(Input.is_action_pressed) and Input.is_action_pressed("running"):
			state_transition.emit("running")
		elif ["forward","backward","left","right"].any(Input.is_action_pressed):
			state_transition.emit("walking")
		else:
			state_transition.emit("idle")



func moving(delta):
	if Input.is_action_pressed("running"):
		SPEED = running_speed
	else:
		SPEED = walking_speed

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (player_ref.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if player_ref.is_on_floor():
		if direction:
			player_ref.velocity.x = direction.x * SPEED
			player_ref.velocity.z = direction.z * SPEED
		else:
			player_ref.velocity.x = lerp(player_ref.velocity.x, direction.x * SPEED, delta * 7.0)
			player_ref.velocity.z = lerp(player_ref.velocity.z, direction.z * SPEED, delta * 7.0)
	else :
		player_ref.velocity.x = lerp(player_ref.velocity.x, direction.x * SPEED, delta * 1.5)
		player_ref.velocity.z = lerp(player_ref.velocity.z, direction.z * SPEED, delta * 1.5)

func jump():
	if Input.is_action_just_pressed("jump") and player_ref.is_on_floor():
		player_ref.velocity.y = JUMP_VELOCITY

func gravity(delta):
	if not player_ref.is_on_floor():
		player_ref.velocity.y += gravity_force * delta
