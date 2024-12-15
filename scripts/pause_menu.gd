extends Control

signal resume_button
signal reset_button
signal player_1_color(index: int)
signal player_2_color(index: int)
signal player_1_ai(index: int)
signal player_2_ai(index: int)

@onready var master_volume: Label = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/MasterNumberLabel
@onready var sfx_volume: Label = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/SFXNumberLabel
@onready var music_volume: Label = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/MusicNumberLabel

@onready var master_mute_button: Button = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/MasterMuteButton
@onready var sfx_mute_button: Button = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/SFXMuteButton
@onready var music_mute_button: Button = $MarginContainer/HBoxContainer/SettingsContainer/AudioVBoxContainer/AudioGridContainer/MusicMuteButton

@onready var master_bus_index = AudioServer.get_bus_index("Master")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var music_bus_index = AudioServer.get_bus_index("Music")

var icon_muted = preload("res://assets/used_art/volume-mute.svg")
var icon_unmuted = preload("res://assets/used_art/volume-high.svg")

var master_muted: bool = false
var sfx_muted: bool = false
var music_muted: bool = false


func _ready() -> void:
	size = get_viewport_rect().size


func _on_resume_button_up() -> void:
	emit_signal("resume_button")


func _on_reset_button_up() -> void:
	emit_signal("reset_button")


func _on_quit_button_up() -> void:
	get_tree().quit()


# color stuff
func _on_player_1_color_selected(index: int) -> void:
	emit_signal("player_1_color", index)


func _on_player_2_color_selected(index: int) -> void:
	emit_signal("player_2_color", index)


# ai stuff
func _on_player_1ai_selected(index: int) -> void:
	emit_signal("player_1_ai", index)


func _on_player_2ai_selected(index: int) -> void:
	emit_signal("player_2_ai", index)


# audio stuff
func _on_master_slider_value_changed(value: float) -> void:
	var db: float
	if value != 0:
		db = linear_to_db(value / 100) + 5
	else:
		db = -500
	AudioServer.set_bus_volume_db(master_bus_index, db)
	master_volume.text = str(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	var db: float
	if value != 0:
		db = linear_to_db(value / 100) + 5
	else:
		db = -500
	AudioServer.set_bus_volume_db(sfx_bus_index, db)
	sfx_volume.text = str(value)


func _on_music_slider_value_changed(value: float) -> void:
	var db: float
	if value != 0:
		db = linear_to_db(value / 100) + 5
	else:
		db = -500
	AudioServer.set_bus_volume_db(music_bus_index, db)
	music_volume.text = str(value)


func _on_master_mute_button_up() -> void:
	if master_muted:
		AudioServer.set_bus_mute(master_bus_index, false)
		master_mute_button.icon = icon_unmuted
	else:
		AudioServer.set_bus_mute(master_bus_index, true)
		master_mute_button.icon = icon_muted
	master_muted = !master_muted


func _on_sfx_mute_button_up() -> void:
	if sfx_muted:
		AudioServer.set_bus_mute(sfx_bus_index, false)
		sfx_mute_button.icon = icon_unmuted
	else:
		AudioServer.set_bus_mute(sfx_bus_index, true)
		sfx_mute_button.icon = icon_muted
	sfx_muted = !sfx_muted


func _on_music_mute_button_up() -> void:
	if music_muted:
		AudioServer.set_bus_mute(music_bus_index, false)
		music_mute_button.icon = icon_unmuted
	else:
		AudioServer.set_bus_mute(music_bus_index, true)
		music_mute_button.icon = icon_muted
	music_muted = !music_muted
