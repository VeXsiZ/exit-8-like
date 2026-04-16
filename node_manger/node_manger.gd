extends Node3D



var dic_of_segments : Dictionary
@export var entress : PackedScene
@export var middle : PackedScene
var active_segments : Array
var segments_pos : Array
var last_direction_spawned = null
var score : int = 0
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
		temp.player_direction.connect(score_handler)
		get_parent().add_child(temp)
		active_segments.append(temp)
		temp.global_position = pos
		sides_locker(caller,temp,dir)
		score_handler(dir,temp,caller)
		last_direction_spawned = dir
		segments_cleaner(caller,temp,dir)
		if temp.get_segment_name_tag() == "entress":
			var anamoly_status_label = get_parent().get_node("anamoly_status")
			if temp.get_anamoly_scene_status():
				anamoly_status_label.text = "anamoly_status : TRUE"
			else:
				anamoly_status_label.text = "anamoly_status : FALSE"


func sides_locker(caller,temp,dir):
	if dir == "forward":
		caller.lock_forward()
		temp.lock_backward()
	elif dir == "backward":
		caller.lock_backward()
		temp.lock_forward()




func on_current_scene_handler(caller):
	if current_scene == null:
		caller.change_current_scene_states(true)
		current_scene = caller
	else:
		current_scene.change_current_scene_states(false)
		caller.change_current_scene_states(true)
		current_scene = caller

func segments_cleaner(caller, temp, dir):
	if active_segments.size() > 2:
		var remaining_segments = []
		segments_pos = []
		for segment in active_segments:
			if segment == caller or segment == temp:
				remaining_segments.append(segment)
			else:
				segment.queue_free()
				if dir == "forward":
					caller.unlock_backward()
				elif dir == "backward":
					caller.unlock_forward()
		active_segments = remaining_segments
		for i in active_segments:
			segments_pos.append(i)



func on_player_load_new_segment(segment,pos,dir,caller):
	hallway_handler(segment,pos,dir,caller)



func score_handler(dir,temp,caller):
	print(score)
