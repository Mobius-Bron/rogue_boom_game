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
var _boom_length: int = 10 #炸弹长度
var _boom_atk: float = 1 #炸弹伤害
var _boom_num: int = 3 #炸弹伤害
var _enemy_list = [] #敌人列表
var _enemy_waves: int = 20 #敌人波次
var score=0 #分数

#怪物属性
var _slim_hp: float = 5
var _slim_atk: float = 1
var _slim_num: int = 0

var _stone_hp: float = 75
var _stone_atk: float = 15
var _stone_num: int = 0

var _magma_hp: float = 1
var _magma_atk: float = 15
var _magma_num: int = 20

var _flame_bat_hp: float = 10
var _flame_bat_atk: float = 5
var _flame_bat_num: int = 0

var Wave_Number

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player.current_health<=0:
		game_over()
	_Select_Screen()
func _input(_event):
	if Input.is_action_just_pressed("click_l"): #and  player.current_health>0
		var new_ = boom.instantiate()
		new_.length = _boom_length
		new_.atk = _boom_atk
		new_.position = $player.global_position
		add_child(new_)

func enemy_dead(name):
	if name in _enemy_list:
		_enemy_list.erase(name)
		score+=5
		
func new_wave():
	_enemy_waves += 1
	$HUD.Wave_Number +=1
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

func new_game():
	score=0
	$player.start($Start_Position.position)
	$Start_Timer.start()
	$HUD.update_score(score)
	$HUD.show_Title_Label("准备")
	get_tree().call_group("enemys","queue_free")
	await get_tree().create_timer(1.0).timeout
	new_wave()

func _on_score_timer_timeout():
	score +=1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$Score_Timer.start()

func game_over():
	#$Score_Timer.stop()
	#$HUD.show_game_over()	
	#player.show_game_over()	
	pass

func _on_mob_timer_timeout():
	pass # Replace with function body.

func _Select_Screen():
	if len(_enemy_list)==0 and score>0:
		await get_tree().create_timer(1.0).timeout
		$HUD/Select1.show()
		$HUD/Select2.show()
		$HUD/Select3.show()
	if len(_enemy_list)!=0:
		$HUD/Select1.hide()
		$HUD/Select2.hide()
		$HUD/Select3.hide()
		
func _on_hud_select():
	await get_tree().create_timer(1.0).timeout
	new_wave()
