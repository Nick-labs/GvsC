class_name DragManager
extends Node


signal drag_finished(context: DragContext)

var context: DragContext


func start_drag(
	object: Node,
	container: Node,
	slot := -1
):
	context = DragContext.new()

	context.setup(
		object,
		container,
		slot
	)


func get_context() -> DragContext:
	return context


func is_dragging() -> bool:
	return context != null


func _process(_delta):
	if context == null:
		return

	context.dragged_object.global_position = \
		get_viewport().get_camera_2d().get_global_mouse_position()


func _unhandled_input(event):
	if context == null:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and not event.pressed:

		drag_finished.emit(context)
		context = null
