extends Node3D
var segment_name_tag = "entress"
var anamoly_scene_status
signal player_entered_from_signal
signal player_go_to_signal

signal player_entered_scene
var current_scene_states = false

signal player_load_new_segment


var can_spawn_forward = true
var forward_spawned = false

var can_spawn_backward = true
var backward_spawned = false

@onready var forward: Marker3D = $forward
@onready var backward: Marker3D = $backward



func _ready() -> void:
	randomize()
	anamoly_scene_status = randi() % 2 == 0

func get_anamoly_scene_status():
	return anamoly_scene_status

func get_segment_name_tag():
	return segment_name_tag



#sides_lockers
#################################################################################
func lock_forward():
	can_spawn_forward = false
	forward_spawned = true

func unlock_forward():
	can_spawn_forward = true
	forward_spawned = false

func lock_backward():
	can_spawn_backward = false
	backward_spawned = true

func unlock_backward():
	can_spawn_backward = true
	backward_spawned = false
#################################################################################



#current scene logic
#################################################################################
#current_scene_setter(work when node manger call it and pass the true state)
func change_current_scene_states(state):
	current_scene_states = state

#check for current segment or scene
func get_current_scene_states():
	var f = "entress " + str(current_scene_states)
	return f

#when player enter the segment its gonna emit signal to fet current scene var to true via node manger
func _on_current_scene_selecter_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_entered_scene.emit(self)
#################################################################################




#spawn new segments signal
#################################################################################
func _on_forward_load_body_entered(body: Node3D) -> void:
	#player_direction.emit("forward")
	if body is CharacterBody3D:
		print("--- FORWARD HIT --- Spawned: ", forward_spawned, " | Can Spawn: ", can_spawn_forward)
		if !forward_spawned and can_spawn_forward:
			lock_forward()
			player_load_new_segment.emit("mid",forward.global_position,"forward",self)

func _on_backward_load_body_entered(body: Node3D) -> void:
	#player_direction.emit("backward")
	if body is CharacterBody3D:
		if !backward_spawned and can_spawn_backward:
			print("--- BACKWARD HIT --- Spawned: ", backward_spawned, " | Can Spawn: ", can_spawn_backward)
			lock_backward()
			player_load_new_segment.emit("mid",backward.global_position,"backward",self)
#################################################################################

var forward_score_activated = false
var backward_score_activated = false

var forward_score_trigired = false
var backward_score_trigired = false

func _on_forward_triger_activator_body_entered(body: Node3D) -> void:
	if !forward_score_activated:
		forward_score_activated = true
		player_entered_from()
		print("forward triger activated")


func _on_forward_real_triger_body_entered(body: Node3D) -> void:
	#if forward_score_trigired:
		#pass
	if forward_score_activated and !forward_score_trigired:
		forward_score_trigired = true
		player_go_to()
		print("forward triger worked")


func _on_backward_triger_activator_body_entered(body: Node3D) -> void:
	if !backward_score_activated:
		backward_score_activated = true
		player_entered_from()
		print("backward triger activated")

func _on_backward_real_triger_body_entered(body: Node3D) -> void:
	#if backward_score_activated:
		#pass
	if backward_score_activated and !backward_score_trigired:
		backward_score_trigired = true
		player_go_to()
		print("backward triger worked")



func player_entered_from():
	if forward_score_activated and !backward_score_activated:
		player_entered_from_signal.emit("forward")
	elif !forward_score_activated and backward_score_activated:
		player_entered_from_signal.emit("backward")

func player_go_to():
	if forward_score_trigired and !backward_score_trigired:
		player_go_to_signal.emit("forward")
	elif !forward_score_trigired and backward_score_trigired:
		player_go_to_signal.emit("backward")
