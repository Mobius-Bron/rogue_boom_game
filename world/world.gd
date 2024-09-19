extends Node2D

var boom = preload("res://player/boom.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("click_l"):
		var new_ = boom.instantiate()
		new_.position = $player.global_position
		add_child(new_)
