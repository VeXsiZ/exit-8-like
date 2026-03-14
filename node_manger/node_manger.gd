extends Node3D



var dic_of_segments : Dictionary
@export var entress : PackedScene
@export var middle : PackedScene
var active_segments : Array
var segments_pos : Array

var current_scene


func _ready() -> void:
	dic_of_segments["ent"] = entress
	dic_of_segments["mid"] = middle
	



func _process(delta: float) -> void:
	pass



func hallway_handler(segment = null,pos = null,dir = null,caller = null):
	if segment == null and pos == null and dir == null and caller == null:
		var temp = middle.instantiate()
		temp.player_load_new_segment.connect(on_player_load_new_segment)
		temp.player_entered_scene.connect(on_current_scene_handler)
		get_parent().add_child(temp)
		temp.global_position = Vector3.ZERO
		active_segments.append(temp)
	else:
		var temp = dic_of_segments[segment].instantiate()
		temp.player_load_new_segment.connect(on_player_load_new_segment)
		temp.player_entered_scene.connect(on_current_scene_handler)
		get_parent().add_child(temp)
		active_segments.append(temp)
		temp.global_position = pos
		sides_locker(caller,temp,dir)
		segments_arranger()
		segments_cleaner(temp,caller,dir)
		print(segments_pos)


func sides_locker(caller,temp,dir):
	if dir == "forward":
		caller.lock_forward()
		temp.lock_backward()
	elif dir == "backward":
		caller.lock_backward()
		temp.lock_forward()


func segments_arranger():
	segments_pos = []
	active_segments.sort_custom(func(a,b): return a.global_position.z < b.global_position.z)
	for i in active_segments:
		segments_pos.append(i.global_position.z)




func on_current_scene_handler(caller):
	if current_scene == null:
		caller.change_current_scene_states(true)
		current_scene = caller
		print(current_scene.get_current_scene_states())
	else:
		current_scene.change_current_scene_states(false)
		print(current_scene.get_current_scene_states())
		caller.change_current_scene_states(true)
		print(caller.get_current_scene_states())
		current_scene = caller

func segments_cleaner(caller, temp, dir):
	if active_segments.size() > 2:
		var remaining_segments = []
		for segment in active_segments:
			if segment != caller and segment != temp:
				segment.queue_free()
				if dir == "forward":
					caller.unlock_backward()
				elif dir == "backward":
					caller.unlock_forward()
			else:
				remaining_segments.append(segment)
		active_segments = remaining_segments



func on_player_load_new_segment(segment,pos,dir,caller):
	hallway_handler(segment,pos,dir,caller)
