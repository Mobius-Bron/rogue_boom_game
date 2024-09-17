extends CharacterBody2D

var speed = 50

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
