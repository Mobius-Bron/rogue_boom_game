extends CharacterBody2D

var get_player: bool = false

@export var max_health = 30
@export var current_health = 30
@export var speed = 50
@export var atk = 1

var player_list = []

@export var player: CharacterBody2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()
	$health_bar.value=current_health
	$health_bar.max_value=max_health


func _physics_process(_delta: float) -> void:
	var dir = to_local(navigationAgent.get_next_path_position()).normalized()
	velocity = dir * speed
	if dir.x > 0.1:
		$AnimatedSprite2D.flip_h = true
	elif dir.x < -0.1:
		$AnimatedSprite2D.flip_h = false
	move_and_slide()

func hurt(atk):
	current_health -= atk
	$health_bar.value=current_health
	if current_health <= 0:
		self.queue_free()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position

func _on_atk_area_area_entered(area):
	if area.name == "player_hurt_area":
		var node = area.get_parent()
		if node not in player_list:
			player_list.append(node)
		get_player = true

func _on_atk_area_area_exited(area):
	if area.name == "player_hurt_area":
		var node = area.get_parent()
		if node in player_list:
			player_list.erase(node)
		get_player = false

func _on_atk_timer_timeout():
	if get_player:
		for player in player_list:
			player.hurt(atk)



