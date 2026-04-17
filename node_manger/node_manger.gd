extends Node3D



var dic_of_segments : Dictionary
@export var entress : PackedScene
@export var middle : PackedScene
var active_segments : Array
var segments_pos : Array
var score : int = 0
var current_scene
@onready var score_counter_label = get_parent().get_node("score_counter")
@onready var anamoly_status_label = get_parent().get_node("anamoly_status")



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
		segments_cleaner(caller,temp,dir)
		if temp.get_segment_name_tag() == "entress":
			active_entress_instance = temp
			temp.player_entered_from_signal.connect(get_where_player_entered_from)
			temp.player_go_to_signal.connect(score_handler)
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




###########################################################################
var where_player_entered_from
var where_player_go_to
var active_entress_instance

func get_where_player_entered_from(player_entered):
	where_player_entered_from = player_entered

func score_handler(player_go_to):
	where_player_go_to = player_go_to

	if active_entress_instance.get_anamoly_scene_status():
		if where_player_entered_from == "forward":
			if where_player_go_to == "backward":
				score += 1
			elif where_player_go_to == "forward":
				score = 0
		elif where_player_entered_from == "backward":
			if where_player_go_to == "forward":
				score += 1
			elif where_player_go_to == "backward":
				score = 0
	elif !active_entress_instance.get_anamoly_scene_status():
		if where_player_entered_from == "forward":
			if where_player_go_to == "forward":
				pass
			elif where_player_go_to == "backward":
				score = 0
		elif where_player_entered_from == "backward":
			if where_player_go_to == "forward":
				score = 0
			elif where_player_go_to == "backward":
				pass
	score_counter_label.text = str(score)
	
	
