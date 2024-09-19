extends CharacterBody2D

var get_player: bool = false

@export var max_hp = 30
var hp = 30
@export var speed = 50
@export var atk = 15

var is_able = true
var player_list = []

@export var player: CharacterBody2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var HP_Label: Label = $HP
@onready var anim_2d = $AnimatedSprite2D

@onready var tilemap = $wave_area/TileMap
@onready var wave = $wave_area

@onready var cx = $wave_area/cx
@onready var cy = $wave_area/cy

var layer: int = 0
@export var length: int = 10
@export var boom_time = 3

var wave_list = [2,0,1,2,3]
var nextTargets = []
var enemyList = []


func _ready():
	cx.scale.x = length + length + 1
	cy.scale.y = length + length + 1
	length += 1
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
	
		if (self.position - player.global_position).length() <= 160:
			is_able = false
			await get_tree().create_timer(1).timeout
			boom_and_dead()
		else:
			wave.look_at(player.global_position)
	
	HP_Label.text = str(int(hp))

func hurt(atk):
	boom_and_dead()

func boom_and_dead():
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
				i.boom_()
	
	for i in enemyList:
		if i != null:
			i.hurt(atk)
	
	self.queue_free()

func _on_timer_timeout():
	navigationAgent.target_position = player.global_position

func _on_wave_area_area_entered(area):
	if area.name == "boom_area":
		var node = area.get_parent()
		print(node.name)
		if node != self:
			nextTargets.append(node)
	elif area.name == "hurt_area":
		var node = area.get_parent()
		print(node.name)
		if node not in enemyList:
			enemyList.append(node)
	elif area.name == "player_hurt_area":
		var node = area.get_parent()
		print(node.name)
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
