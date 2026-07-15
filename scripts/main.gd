extends Node2D

@onready var intro: Intro = $Intro

@onready var farm = $Farm
@onready var farm_ui = $Farm/FarmUI


@onready var defense = $Defense
@onready var shop = $Shop


func _ready():
	set_language()
	_start_game()


func _start_game():
	farm.hide()
	farm_ui.hide()
	shop.hide()
	
	TimeManager.pause()
	
	AudioManager.play_music_by_name("intro")
	await intro.play()
	
	TimeManager.resume()

	initialize()
	
	show_farm()
	AudioManager.play_music_by_name("farm")
	
	_show_welcome()

func initialize():
	farm.farm_ui.shop_pressed.connect(show_shop)
	farm.farm_ui.defense_pressed.connect(show_defense)
	
	defense.farm_pressed.connect(show_farm)
	
	shop.farm_pressed.connect(show_farm)
	
	PlayerData.victory.connect(_on_victory)
	
	defense.farm_destroyed.connect(_on_farm_destroyed)


func _show_welcome():
	var dialog := AcceptDialog.new()

	dialog.title = "Welcome to the game!"
	dialog.dialog_text = \
		"Your goal is to accumulate 5,000 pennies.\n\n" + \
		"Breed rarer pigeon species,\ncollect eggs, and sell them."

	add_child(dialog)
	dialog.popup_centered()


func _connect_farm_ui(ui):
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

	dialog.dialog_text = "Win!"

	add_child(dialog)

	dialog.popup_centered()


func _on_warning_requested(text, duration):
	await UIManager.show_message(text, duration)


func _on_farm_destroyed():
	farm.loft.kill_pigeons()


func set_language(language = "automatic"):
	if language == "automatic":
		language = OS.get_locale_language()

	TranslationServer.set_locale(language)
