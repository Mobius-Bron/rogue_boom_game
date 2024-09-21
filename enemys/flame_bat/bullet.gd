extends CharacterBody2D

var dir=Vector2.ZERO
var speed=100
var hurt=2

func _ready():
	$AnimatedSprite2D.play("shoot")
	await get_tree().create_timer(15).timeout
	queue_free()

func _process(_delta):
	velocity=dir*speed
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.name == "hurt_area" or "player_hurt_area":
		var node = area.get_parent()
		if node != null and node != self:
			node.hurt(hurt)
