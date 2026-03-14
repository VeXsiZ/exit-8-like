extends Node3D

signal player_entered_scene
var current_scene_states = false

signal player_load_new_segment

var can_spawn_forward = true
var forward_spawned = false

var can_spawn_backward = true
var backward_spawned = false

@onready var forward: Marker3D = $forward
@onready var backward: Marker3D = $backward








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

func change_current_scene_states(state):
	current_scene_states = state

func get_current_scene_states():
	var f = "middle " + str(current_scene_states)
	return f

func _on_current_scene_selecter_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_entered_scene.emit(self)


func _on_forward_load_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if !forward_spawned and can_spawn_forward:
			print("dd")
			lock_forward()
			player_load_new_segment.emit("ent",forward.global_position,"forward",self)


func _on_backward_load_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if !backward_spawned and can_spawn_backward:
			print("dd")
			lock_backward()
			player_load_new_segment.emit("ent",backward.global_position,"backward",self)
