extends Control

@export var player_1_zone: Area2D
@export var player_2_zone: Area2D
@export var ball: CharacterBody2D
@onready var player_1_label: Label = $GridContainer/Player1
@onready var player_2_label: Label = $GridContainer/Player2
@onready var countdown_label: Label = $ResetCountdown
@onready var middle: Vector2 = get_viewport_rect().size / 2
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
var p1_score: int = 0
var p2_score: int = 0
var countdown: float = 0

func _ready() -> void:
	assert(player_1_zone and player_2_zone and ball)
	player_1_zone.body_entered.connect(ball_enters_p1)
	player_2_zone.body_entered.connect(ball_enters_p2)

	size = get_viewport_rect().size


func _process(delta: float) -> void:
	if countdown > 0:
		countdown -= delta

	ball.frozen = countdown > 0


func ball_enters_p1(_ball: CharacterBody2D) -> void:
	countdown = 3
	p2_score += 1
	player_2_label.text = str(p2_score)
	ball.velocity = Vector2(1, (randf() - 0.5) * 0.8).normalized() * ball.speed
	ball.set_collision_mask_value(2, true)
	ball.set_collision_mask_value(4, true)
	audio.play()


func ball_enters_p2(_ball: CharacterBody2D) -> void:
	countdown = 3
	p1_score += 1
	player_1_label.text = str(p1_score)
	ball.velocity = Vector2(-1, (randf() - 0.5) * 0.8).normalized() * ball.speed
	ball.set_collision_mask_value(2, true)
	ball.set_collision_mask_value(4, true)
	audio.play()


func reset() -> void:
	p1_score = 0
	p2_score = 0
	player_1_label.text = str(p1_score)
	player_2_label.text = str(p2_score)
	countdown = 3
