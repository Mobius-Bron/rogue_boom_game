extends CharacterBody2D

@export var max_health: float = 60
var current_health: float = max_health
@export var speed = 20
@export var atk = 15

var enemy_list = []
var is_able = true
var get_player = false

@export var player: CharacterBody2D
@export var world: Node2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var anim_2d = $AnimatedSprite2D
@onready var health_bar = $health_bar


func _ready():
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()
	current_health = max_health
	health_bar.value = current_health
	health_bar.max_value = max_health

func _physics_process(_delta: float) -> void:
	if is_able:
		var dir = to_local(navigationAgent.get_next_path_position()).normalized()
		velocity = dir * speed
		if dir.x > 0.1:
			anim_2d.flip_h = false
		elif dir.x < -0.1:
			anim_2d.flip_h = true
		move_and_slide()
		
		if get_player:
			is_able = false
			$AnimatedSprite2D.animation = "atk"
			await get_tree().create_timer(3).timeout
			for i in enemy_list:
				if i != null:
					i.hurt(atk)
			is_able = true
			
			$AnimatedSprite2D.animation = "walk"

func hurt(_atk):
	current_health -= _atk
	health_bar.value=current_health
	if current_health <= 0:
		world.enemy_dead(self.name)
		self.queue_free()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position

func _on_atk_area_area_entered(area):
	if area.name == "hurt_area":
		var node = area.get_parent()
		if node not in enemy_list and node != self:
			enemy_list.append(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		if node not in enemy_list:
			get_player = true
			enemy_list.append(node)

func _on_atk_area_area_exited(area):
	if area.name == "hurt_area":
		var node = area.get_parent()
		if node in enemy_list:
			enemy_list.erase(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		if node in enemy_list:
			get_player = false
			enemy_list.erase(node)

