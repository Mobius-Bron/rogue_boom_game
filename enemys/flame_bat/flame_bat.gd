extends CharacterBody2D

var get_player: bool = false
var player_list = []
var bullet_shoot_time=2
var bullet_speed=1000
var bullet_hurt=10
var attack_player=[]
@export var max_health: float = 15
@export var current_health: float = max_health
@export var speed = 50
@export var atk = 1
@export var player: CharacterBody2D
@export var world: Node2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var bullet=preload("res://enemys/flame_bat/bullet.tscn")

func _ready():
	$AnimatedSprite2D.play("walk")
	current_health = max_health
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
		world.enemy_dead(self.name)
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

func _on_shoot_timer_timeout():
	var bullet_new = bullet.instantiate()
	bullet_new.position=$shoot_position.global_position.normalized()
	bullet_new.dir=player.global_position.normalized()
	get_tree().root.add_child(bullet_new)

func _on_shoot_area_area_entered(area):
	if area.name == "player_hurt_area" :
		$shoot_timer.start()
		
func _on_shoot_area_area_exited(area):
	if area.name == "player_hurt_area" :
		$shoot_timer.stop()
