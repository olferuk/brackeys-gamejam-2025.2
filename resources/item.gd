class_name Item
extends Resource

@export var name: String
@export var sprite_paths: Array[String]
@export var floaty: bool = false

@export_group("Capabilities")
@export var pushable: bool = false
@export var interactable: bool = false
@export var damaging: bool = false
