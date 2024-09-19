extends Node2D

#场景
var boom = preload("res://player/boom.tscn")
var slim = preload("res://enemys/slim/slim.tscn")
var stone = preload("res://enemys/stone/stone.tscn")
var magma = preload("res://enemys/magma/magma.tscn")
var flame_bat = preload("res://enemys/flame_bat/flame_bat.tscn")

#玩家属性与当前游戏属性
@export var player:CharacterBody2D
var hard #难度
var _boom_length: int = 3 #炸弹长度
var _boom_atk: float = 1 #炸弹伤害
var _boom_num: int = 3 #炸弹伤害
var _enemy_list = [] #敌人列表
var _enemy_turns: int = 0 #敌人波次

#怪物属性
var _slim_hp: float = 5
var _slim_atk: float = 1
var _slim_num: int = 10

var _stone_hp: float = 75
var _stone_atk: float = 15
var _stone_num: int = 5

var _magma_hp: float = 1
var _magma_atk: float = 15
var _magma_num: int = 5

var _flame_bat_hp: float = 10
var _flame_bat_atk: float = 5
var _flame_bat_num: int = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	new_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if len(_enemy_list) == 0:
		new_turn()

func _input(_event):
	if Input.is_action_just_pressed("click_l"):
		var new_ = boom.instantiate()
		new_.length = _boom_length
		new_.atk = _boom_atk
		new_.position = $player.global_position
		add_child(new_)

func enemy_dead(name):
	if name in _enemy_list:
		_enemy_list.erase(name)

func new_turn():
	_enemy_turns += 1
	add_enemy(slim, _slim_num, _slim_hp, _slim_atk, "slim")
	add_enemy(stone, _stone_num, _stone_hp, _stone_atk, "stone")
	add_enemy(magma, _magma_num, _magma_hp, _magma_atk, "magma")
	add_enemy(flame_bat, _flame_bat_num, _flame_bat_hp, _flame_bat_atk, " flame_bot")

func add_enemy(enemy_type, enemy_num, enemy_hp, enemy_atk, enemy_name):
	var new_position: Vector2
	for i in enemy_num:
		var new_enemy_ = enemy_type.instantiate()
		new_enemy_.max_health = enemy_hp
		new_enemy_.atk = enemy_atk
		new_enemy_.player = player
		new_enemy_.world = self
		new_enemy_.name = enemy_name + str(i)
		while(1):
			new_position = Vector2(randf_range(-759,759), randf_range(-496, 494))
			if (new_position - player.global_position).length() >= 160:
				break
		new_enemy_.global_position = new_position
		_enemy_list.append(new_enemy_.name)
		add_child(new_enemy_)
