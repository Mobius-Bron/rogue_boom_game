extends CharacterBody2D

var speed = 150

@export var player: CharacterBody2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var dir = to_local(navigationAgent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position
