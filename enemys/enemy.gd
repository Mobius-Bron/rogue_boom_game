extends CharacterBody2D

var speed = 50
var atk = 1

@export var max_hp = 30
var hp = 30

@export var player: CharacterBody2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var HP_Label: Label = $HP

func _physics_process(_delta: float) -> void:
	var dir = to_local(navigationAgent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
	HP_Label.text = str(int(hp))
	
func hurt(atk):
	hp -= atk
	if hp <= 0:
		self.queue_free()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position

func _on_atk_area_area_entered(area):
	if area.name == "hurt_area":
		var node = area.get_parent()
		if node.name == "player":
			node.hurt(atk)

func _on_atk_area_area_exited(area):
	pass # Replace with function body.
