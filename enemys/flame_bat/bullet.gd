extends CharacterBody2D

var dir=Vector2.ZERO
var speed=1000
var hurt=10

func _ready():
	$AnimatedSprite2D.play("shoot")
	await get_tree().create_timer(15).timeout
	queue_free()

func _process(_delta):
	velocity=dir*speed
	move_and_slide()
