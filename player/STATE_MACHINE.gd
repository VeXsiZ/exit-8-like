extends Node
class_name STATE_MACHINE

var dic_of_states : Dictionary
var current_state : STATE


func _ready() -> void:
	for i in get_children():
		if i is STATE:
			dic_of_states[i.name] = i
			i.player_ref = get_parent()
			i.state_transition.connect(on_state_transition)
	current_state = dic_of_states["mid-air"]


func _process(delta: float) -> void:
	current_state.update()
	


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func on_state_transition(new_state):
	current_state.exite()
	current_state = dic_of_states[new_state]
	current_state.enter()
