extends Node2D

var boom = preload("res://player/boom.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("click_l"):
		var new_ = boom.instantiate()
		var mouse_pos = get_global_mouse_position()
		new_.position = mouse_pos
		add_child(new_)
