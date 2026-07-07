extends Node


var scenes = {
	"farm": "res://scenes/farm/farm.tscn",
	"shop": "res://scenes/shop/shop.tscn",
	"defense": "res://scenes/defense/defense.tscn"
}


func change_scene(scene_name: String):
	if not scenes.has(scene_name):
		push_error("Unknown scene: " + scene_name)
		return

	get_tree().change_scene_to_file(scenes[scene_name])
