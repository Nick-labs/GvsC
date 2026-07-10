extends Node2D

@onready var intro: Intro = $Intro

@onready var farm = $Farm
@onready var farm_ui = $Farm/FarmUI


@onready var defense = $Defense
@onready var shop = $Shop


func _ready():
	_start_game()


func _start_game():
	farm.hide()
	farm_ui.hide()
	shop.hide()

	await intro.play()

	initialize()


func initialize():
	farm.farm_ui.shop_pressed.connect(show_shop)
	farm.farm_ui.defense_pressed.connect(show_defense)
	
	defense.farm_pressed.connect(show_farm)
	
	shop.farm_pressed.connect(show_farm)
	
	PlayerData.victory.connect(_on_victory)

	MusicPlayer.play_music(
		preload("res://assets/audio/music/test4_OrganFluit.ogg")
	)
	
	show_farm()


func _show_intro():
	var dialog := AcceptDialog.new()

	dialog.title = "Добро пожаловать!"
	dialog.dialog_text = \
		"Ваша цель — накопить 5000 грошей.\n\n" + \
		"Разводите голубей, выводя более редкие виды,\nсобирайте более редкие и дорогие яйца, " + \
		"продавайте и то, и другое."

	add_child(dialog)
	dialog.popup_centered()


func _connect_farm_ui(ui):
	print("connect")
	ui.shop_pressed.connect(show_shop)
	ui.defense_pressed.connect(show_defense)


func show_farm():
	if shop.active:
		TimeManager.skip_minutes(30)
	
	farm.visible = true
	defense.visible = false
	shop.visible = false

	farm.set_active(true)
	defense.set_active(false)
	shop.set_active(false)
	
	farm.farm_ui.show()
	


func show_defense():
	farm.visible = false
	defense.visible = true
	shop.visible = false

	farm.set_active(false)
	defense.set_active(true)
	shop.set_active(false)
	
	farm.farm_ui.hide()


func show_shop():
	TimeManager.skip_minutes(30)
	
	farm.visible = false
	defense.visible = false
	shop.visible = true

	farm.set_active(false)
	defense.set_active(false)
	shop.set_active(true)
	
	farm.farm_ui.hide()


func _on_victory():
	var dialog := AcceptDialog.new()

	dialog.dialog_text = "Победа! Вы накопили 5000 грошей!"

	add_child(dialog)

	dialog.popup_centered()


func _on_warning_requested(text, duration):
	await UIManager.show_message(text, duration)
