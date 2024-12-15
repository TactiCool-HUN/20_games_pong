extends AudioStreamPlayer2D

@onready var music_1 = preload("res://assets/sounds/music/city-lights-vens-adams-main-version-27952-01-56.mp3")
@onready var music_2 = preload("res://assets/sounds/music/neon-signs-simon-folwar-main-version-6833-02-40.mp3")
@onready var music_3 = preload("res://assets/sounds/music/stardust-danijel-zambo-main-version-1372-03-13.mp3")
var music_choices: Array
var current: int

func _ready() -> void:
	music_choices = [music_1, music_2, music_3]
	switch_track()


func _process(_delta: float) -> void:
	if !playing:
		switch_track()


func switch_track() -> void:
	var i: int = current
	while i == current:
		i = randi_range(0, 2)
	stream = music_choices[i]
	current = i
	play()
