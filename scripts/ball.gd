extends CharacterBody2D

@export var speed: int = 400

@onready var pointer: Marker2D = $Marker2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var bounce_sound_1 = preload("res://assets/sounds/bounce_1.mp3")
@onready var bounce_sound_2 = preload("res://assets/sounds/bounce_2.mp3")
@onready var bounce_sound_3 = preload("res://assets/sounds/bounce_3.mp3")
@onready var bounce_sound_4 = preload("res://assets/sounds/bounce_4.mp3")
var frozen: bool = false


func _ready() -> void:
	var y: float = (randf() - 0.5) * 0.8
	velocity = Vector2(1, y).normalized() * speed
	global_position = get_viewport_rect().size / 2
	$Sprite2D/AnimationPlayer.play("ballin")


func _process(_delta: float) -> void:  # laser pointer stuff
	pointer.rotation = Vector2(velocity.x, velocity.y).angle()


func _physics_process(delta: float) -> void:
	if frozen:
		global_position = get_viewport_rect().size / 2
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("pedal"):
			var move_direction_l: bool = velocity.x < 0
			var pedal_side_l: bool = (get_viewport_rect().size / 2).x > global_position.x
			if move_direction_l == pedal_side_l:
				velocity = pedal_bounce(collision).normalized() * speed
				play_bounce_audio()
		else:
			velocity = velocity.bounce(collision.get_normal()).normalized() * speed
			play_bounce_audio()


func pedal_bounce(collision: KinematicCollision2D) -> Vector2:
	if collision.get_collider_shape_index() == 1:
		return Vector2(velocity.x, -velocity.y)

	var collider = collision.get_collider()
	var col_y = collider.global_position.y
	var ball_y: float = global_position.y
	var half_height: int = collider.get_child(1).shape.size.y / 2
	var y: float = (ball_y - col_y) / half_height
	return Vector2(-velocity.x/abs(velocity.x), y)


func reset() -> void:
	var y: float = (randf() - 0.5) * 0.8
	velocity = Vector2(1, y).normalized() * speed
	global_position = get_viewport_rect().size / 2


func play_bounce_audio():
	match randi_range(0, 3):
		0:
			audio_player.stream = bounce_sound_1
		1:
			audio_player.stream = bounce_sound_2
		2:
			audio_player.stream = bounce_sound_3
		3:
			audio_player.stream = bounce_sound_4
	audio_player.play()
