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
var _boom_length: int = 2 #炸弹长度
var _boom_atk: float = 1 #炸弹伤害
var _boom_num: int = 0 #炸弹数量
var _boom_max_num: int = 3 #炸弹最大数量
var _enemy_list = [] #敌人列表
var _enemy_waves: int = 20 #敌人波次
var score=0 #分数
var Wave_Number #波数
var text1=0 #rogue词条字典的随机文本
var text2=0 #rogue词条字典的随机文本
var text3=0 #rogue词条字典的随机文本
var key1=0 #rogue词条字典的随机key
var key2=0 #rogue词条字典的随机key
var key3=0 #rogue词条字典的随机key
var select=0 #rogue词条选择后判断使用的变量
#怪物属性
var _slim_hp: float = 5
var _slim_atk: float = 1
var _slim_num: int = 0

var _stone_hp: float = 75
var _stone_atk: float = 15
var _stone_num: int = 0

var _magma_hp: float = 1
var _magma_atk: float = 15
var _magma_num: int = 1

var _flame_bat_hp: float = 10
var _flame_bat_atk: float = 5
var _flame_bat_num: int = 0

#rogue词条字典
var rogue_dict ={
	0:"炸弹伤害+1",
	1:"炸弹长度+1",
	2:"玩家最大生命值\n加10",
	3:"玩家炸弹数量\n+1",
	4:"玩家移速+5",
	
	5:"史莱姆数量+1",
	6:"史莱姆伤害+1",
	7:"史莱姆生命值+5",
	
	8:"蝙蝠数量+1",
	9:"蝙蝠伤害+2",
	10:"蝙蝠生命值+1",
	
	11:"石头先辈数量+1",
	12:"石头先辈伤害+5",
	13:"石头先辈生命值+10",
	
	14:"滚动披萨数量+1",
	15:"滚动披萨伤害+3",
}

func _ready():
	pass

func _process(_delta):
	if player.current_health<=0:
		game_over()
	_Select_Screen()
	
func _input(_event):
	if Input.is_action_just_pressed("click_l") and  player.current_health>0 and _boom_num<_boom_max_num:
		var new_ = boom.instantiate()
		new_.length = _boom_length
		new_.atk = _boom_atk
		new_.position = $player.global_position
		new_.world=$"."
		_boom_num +=1
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
	player.current_health=player.max_health
	await get_tree().create_timer(1.0).timeout
	new_wave()

func _on_score_timer_timeout():
	score +=1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$Score_Timer.start()

func game_over():
	$Score_Timer.stop()
	$HUD.show_game_over()	
	player.show_game_over()	

func _Select_Screen():
	if len(_enemy_list)==0 and score>0:
		$HUD/Select1.text=text1
		$HUD/Select2.text=text2
		$HUD/Select3.text=text3
		await get_tree().create_timer(1.0).timeout
		$HUD/Select1.show()
		$HUD/Select2.show()
		$HUD/Select3.show()
	if len(_enemy_list)!=0:
		key1=randi_range(0,0)
		key2=randi_range(0,4)
		key3=randi_range(0,4)
		text1=rogue_dict[key1]
		text2=rogue_dict[key2]
		text3=rogue_dict[key3]
		$HUD/Select1.hide()
		$HUD/Select2.hide()
		$HUD/Select3.hide()
		
func _on_hud_select_1():
	select=key1
	level_up()
	await get_tree().create_timer(1.0).timeout
	new_wave()

func _on_hud_select_2():
	select=key2
	level_up()
	await get_tree().create_timer(1.0).timeout
	new_wave()

func _on_hud_select_3():
	select=key3
	level_up()
	await get_tree().create_timer(1.0).timeout
	new_wave()

#rogue选择后的player和enemy的升级
func level_up():
	if select==0:
		_boom_atk +=1
	if select==1:
		_boom_length +=1
	if select==2:
		player.max_health +=10
		player.current_health +=10
	if select==3:
		_boom_max_num +=1
	if select==4:
		player.SPEED +=5
	if select==5:
		_slim_num +=1
	if select==6:
		_slim_atk +=1
	if select==7:
		_stone_hp +=5
	if select==8:
		_flame_bat_num +=1
	if select==9:
		_flame_bat_atk +=2
	if select==10:
		_flame_bat_hp +=1
	if select==11:
		_stone_num +=1
	if select==12:
		_stone_atk +=5
	if select==13:
		_stone_hp +=10
	if select==14:
		_magma_num +=1
	if select==15:
		_magma_atk +=3

