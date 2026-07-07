class_name PigeonData
extends Resource

@export_group("Breed")
@export var breed_name: String
@export var sprite: Texture2D
@export var price: int
@export var egg_interval_minutes: int
@export var egg_template: EggData
@export var rarity: float = 1.0

@export_group("Individual")
var nickname := ""
var age := 0
var eggs_laid := 0
var generation := 1
var parents: Array[PigeonData] = []
