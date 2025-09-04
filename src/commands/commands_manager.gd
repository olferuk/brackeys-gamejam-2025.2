extends Node

var history: Array = []
var limit: int = 50

func push(entities: Array):
	var snapshot: Array = []
	for e in entities:
		snapshot.append(e.serialize_state())
	history.append(snapshot)

	if history.size() > limit:
		history.pop_front()

func undo():
	if history.is_empty():
		return
	var snapshot = history.pop_back()
	for state in snapshot:
		var entity = instance_from_id(state.entity_id)
		if entity and entity.is_inside_tree():
			entity.deserialize_state(state)
