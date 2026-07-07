class_name DragContext
extends RefCounted

var dragged_object: Node
var source_container: Node
var source_slot: int = -1


func setup(
	object: Node,
	container: Node,
	slot: int = -1
):
	dragged_object = object
	source_container = container
	source_slot = slot
