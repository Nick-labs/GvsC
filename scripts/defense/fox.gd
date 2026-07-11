class_name Fox
extends CharacterBody2D

signal died

@export var speed := 60.0
@export var max_hp := 3
@export var attack_distance := 110.0
@export var attack_damage := 5
@export var attack_interval := 1.0
@export var defeat_time := 2.0

var hp := max_hp
var attack_timer := 0.0
var target:Node2D = null
var is_dead := false

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar:ProgressBar = $HPBar

func _ready():
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	sprite.play("default")

func _physics_process(delta):
	if is_dead:
		return

	if target == null:
		return

	var distance = global_position.distance_to(target.global_position)

	if distance > attack_distance:
		move_to_target()
	else:
		attack(delta)

func move_to_target():
	var direction = (target.global_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

	sprite.play("walk")

	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func attack(delta):
	velocity = Vector2.ZERO

	sprite.play("attack")

	attack_timer -= delta

	if attack_timer <= 0:
		target.take_damage(attack_damage)
		attack_timer = attack_interval

func take_damage(damage:int):
	if is_dead:
		return

	hp -= damage
	hp_bar.value = hp

	if hp <= 0:
		defeat()

func defeat():
	is_dead = true
	velocity = Vector2.ZERO

	hp_bar.hide()

	sprite.play("defeat")

	await get_tree().create_timer(defeat_time).timeout

	died.emit()
	queue_free()
