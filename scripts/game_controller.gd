extends Node2D

@onready var pause_menu: Control = $PauseMenu
@onready var player_1: CharacterBody2D = $Players/Pedal1
@onready var player_2: CharacterBody2D = $Players/Pedal2
@onready var ball: CharacterBody2D = $Ball
@onready var hud: Control = $GameHUD
var ai_array: Array = ["human", "easy_ai", "hard_ai"]
var paused: bool = false


func _ready() -> void:
	player_1.ball = ball
	player_2.ball = ball

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()


func pause() -> void:
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		Engine.time_scale = 0
		pause_menu.show()
	
	paused = !paused


func _on_resume_button() -> void:
	pause()


func _on_reset_button() -> void:
	ball.reset()
	hud.reset()


func _on_player_1_color_change(index: int) -> void:
	player_1.change_color(index)


func _on_player_2_color_change(index: int) -> void:
	player_2.change_color(index)


func _on_player_1_ai_change(index: int) -> void:
	player_1.controller = ai_array[index]


func _on_player_2_ai_change(index: int) -> void:
	player_2.controller = ai_array[index]
