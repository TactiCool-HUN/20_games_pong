extends Label

@onready var parent: Control = get_parent()


func _process(_delta: float) -> void:
	var countdown: float = parent.countdown
	if 2 < countdown and countdown <= 3:
		text = "3"
	elif 1 < countdown and countdown <= 2:
		text = "2"
	elif 0 < countdown and countdown <= 1:
		text = "1"
	else:
		text = ""
