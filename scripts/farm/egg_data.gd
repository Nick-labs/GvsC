class_name EggData
extends Resource

@export var name: String
@export var price: int = 1
@export var texture: Texture2D

@export var parent_data: PigeonData

@export var hatch_time_minutes := 3.0

@export var tier: int
@export var hatch_chances: Array[HatchChance]
