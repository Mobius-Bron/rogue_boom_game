extends CharacterBody2D

var get_player: bool = false

@export var max_health: float = 30
var current_health: float = max_health
@export var speed = 30
@export var atk = 15

var is_able = true
var player_list = []

@export var player: CharacterBody2D
@export var world: Node2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var anim_2d = $AnimatedSprite2D

@onready var tilemap = $wave_area/TileMap
@onready var wave = $wave_area

@onready var cx = $wave_area/cx
@onready var cy = $wave_area/cy
@onready var colorx = $wave_area/cx/ColorX
@onready var colory = $wave_area/cy/ColorY

var layer: int = 0
@export var length: int = 10
var length_ = length + length + 1
@export var boom_time = 1

var wave_list = [2,0,1,2,3]
var nextTargets = []
var enemyList = []


func _ready():
	cx.scale.x = length_
	cy.scale.y = length_
	colorx.scale.x = 0
	colory.scale.y = 0
	length += 1
	current_health = max_health
	$AnimatedSprite2D.animation = "run"
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
	
		if (self.position - player.global_position).length() <= 160:
			boom_and_dead()
		else:
			wave.look_at(player.global_position)

func hurt(_atk):
	boom_and_dead()

func boom_and_dead():
	is_able = false
	colorx.scale.x = 1
	colory.scale.y = 1
	$AnimatedSprite2D.animation = "boom"
	await get_tree().create_timer(boom_time).timeout
	for i in wave_list:
		var pos = Vector2i(0, 0)
		tilemap.set_cell(layer, pos, 0, Vector2i(i, 1))
		for x in range(1,length):
			pos = Vector2i(x, 0)
			tilemap.set_cell(layer, pos, 0, Vector2i(i, 0))
			pos = Vector2i(-x, 0)
			tilemap.set_cell(layer, pos, 0, Vector2i(i, 0))
			pos = Vector2i(0, x)
			tilemap.set_cell(layer, pos, 0, Vector2i(i, 2))
			pos = Vector2i(0, -x)
			tilemap.set_cell(layer, pos, 0, Vector2i(i, 2))
			
		await get_tree().create_timer(0.05).timeout
	
	for i in nextTargets:
		if i != null:
			if i.isable:
				i.atk += atk
				i.boom_()
	
	for i in enemyList:
		if i != null:
			i.hurt(atk)
	
	world.enemy_dead(self.name)
	self.queue_free()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position

func _on_wave_area_area_entered(area):
	if area.name == "boom_area":
		var node = area.get_parent()
		if node != self:
			nextTargets.append(node)
	elif area.name == "hurt_area":
		var node = area.get_parent()
		if node not in enemyList:
			enemyList.append(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		if node not in enemyList:
			enemyList.append(node)

func _on_wave_area_area_exited(area):
	if area.name == "boom_area":
		var node = area.get_parent()
		if node != self:
			nextTargets.erase(node)
	elif area.name == "hurt_area":
		var node = area.get_parent()
		if node in enemyList:
			enemyList.erase(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		if node in enemyList:
			enemyList.erase(node)
