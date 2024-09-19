extends CharacterBody2D

@export var max_hp = 20
var hp = 30
@export var speed = 20
@export var atk = 15

var enemy_list = []
var is_able

@export var player: CharacterBody2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var HP_Label: Label = $HP
@onready var anim_2d = $AnimatedSprite2D


func _ready():
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()

func _physics_process(_delta: float) -> void:
	if is_able:
		var dir = to_local(navigationAgent.get_next_path_position()).normalized()
		velocity = dir * speed
		if dir.x > 0.1:
			anim_2d.flip_h = false
		elif dir.x < -0.1:
			anim_2d.flip_h = true
		move_and_slide()
		
	HP_Label.text = str(int(hp))

func hurt(_atk):
	hp -= _atk
	if hp <= 0:
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
			enemy_list.append(node)

func _on_atk_area_area_exited(area):
	if area.name == "hurt_area":
		var node = area.get_parent()
		if node in enemy_list:
			enemy_list.erase(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		if node in enemy_list:
			enemy_list.erase(node)

func _on_atk_timer_timeout():
	is_able = false
	await get_tree().create_timer(1.5).timeout
	for i in enemy_list:
		if i != null:
			i.hurt(atk)
	is_able = true
