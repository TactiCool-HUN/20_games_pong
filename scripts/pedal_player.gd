extends CharacterBody2D

@export var speed: int = 200
@export var player: String
@onready var up: String = "p" + player + "_up"
@onready var down: String = "p" + player + "_down"
var direction: Vector2
var controller: String

var ball: CharacterBody2D

@onready var sprite: NinePatchRect = $NinePatchRect
var purple = preload("res://assets/used_art/pedal_purple.png")
var green = preload("res://assets/used_art/pedal_green.png")
var red = preload("res://assets/used_art/pedal_red.png")
var colors: Array = [purple, green, red]


func _ready() -> void:
	assert(player == "1" or player == "2")
	set_collision_layer_value(int(player), true)

	var y = (get_viewport_rect().size / 2).y
	if player == "1":
		global_position = Vector2((get_viewport_rect().size * 1 / 10).x, y)
		controller = "human"
	else:
		global_position = Vector2((get_viewport_rect().size * 9 / 10).x, y)
		controller = "easy_ai"
		change_color(2)
		rotate(PI)


func _physics_process(delta: float) -> void:
	get_input()
	global_position += velocity * delta

	if global_position.y < 57:
		global_position.y = 57
	elif global_position.y > 587:
		global_position.y = 587


func get_input() -> void:
	match controller:
		"human":
			direction = Vector2(0, -Input.get_axis(down, up)).normalized()
		"easy_ai":
			direction = Vector2(0, ball.global_position.y - global_position.y).normalized()
		"hard_ai":
			direction = hard_ai_thinkimf()
		_:
			assert(false, "pedal " + player + " controller type not recognized")

	velocity = direction * speed


func hard_ai_thinkimf():
	# var is_ball_below_me: bool = ball.global_position.y > global_position.y
	var go_home: Vector2 = Vector2(0, (get_viewport_rect().size / 2).y - global_position.y).normalized()
	var go_ball: Vector2 = Vector2(0, ball.global_position.y - global_position.y).normalized()
	
	var am_I_left: bool = global_position.x < (get_viewport_rect().size / 2).x
	if ball.velocity.x > 0 and am_I_left:
		return go_home
	
	var ball_angle: float = rad_to_deg(ball.velocity.angle())
	if ball_angle < 0:
		ball_angle = -ball_angle
	if ball_angle > 90:
		ball_angle = 180 - ball_angle

	# on flat ball: follow
	if ball_angle < 30:
		return go_ball

	var is_ball_on_my_side: bool = (ball.global_position.x < (get_viewport_rect().size / 2).x) == am_I_left
	if is_ball_on_my_side:
		var me_x: float = global_position.x
		var mid_x: float = (get_viewport_rect().size / 2).x
		var ball_x: float = ball.global_position.x
		var proportional_x: float = (ball_x - min(me_x, mid_x)) / abs(me_x - mid_x)
		var target_y_raw = ball.global_position.y - ball.global_position.y * proportional_x + (get_viewport_rect().size / 2).y * proportional_x
		var target_y = target_y_raw - global_position.y
		# print("ball: " + str(ball.global_position.y) + " | prop: " + str(proportional_x) + " | target: " + str(target_y))
		return Vector2(0, target_y).normalized()
	else:
		return go_home


func change_color(index: int) -> void:
	sprite.texture = colors[index]
