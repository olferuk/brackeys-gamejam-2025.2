class_name EntityState
extends RefCounted

var entity_id: int
var data: Dictionary

func _init(entity, fields: Array[String]):
	entity_id = entity.get_instance_id()
	data = {}
	for f in fields:
		data[f] = entity.get(f)

func restore(entity):
	for k in data.keys():
		entity.set(k, data[k])
