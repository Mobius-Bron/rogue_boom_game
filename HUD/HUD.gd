extends CanvasLayer

signal  start_game
signal  select1
signal  select2
signal  select3
signal  select4
signal  select5
signal  select6
# Called when the node enters the scene tree for the first time.
@export var player:CharacterBody2D
@export var world:Node2D
var Wave_Number=0
var select_x=0

func _ready():
	$Select1.hide()
	$Select2.hide()
	$Select3.hide()
	$Select4.hide()
	$Select5.hide()
	$Select6.hide()
	$Pause_button.hide()
func _process(delta):
	$Health_Bar.value=player.current_health
	$Health_Label.text = str(player.current_health)
	$Wave_Number_Label.text=str(Wave_Number)

func show_Title_Label(text):
	$Title_Label.text = text
	$Title_Label.show()
	$Title_Label_Timer.start()

func show_game_over():
	show_Title_Label("游戏结束")
	await get_tree().create_timer(2.0).timeout
	
	$Title_Label.text = "炸弹人rogue"
	$Title_Label.show()
	
	await get_tree().create_timer(1.0).timeout
	$Start_button.show()
	
func update_score(score):
	$Score_Label.text = str(score)

func _on_start_button_pressed():
	$Start_button.hide()
	start_game.emit()

func _on_title_label_timer_timeout():
	$Title_Label.hide()

func _on_select_1_pressed():
	$Select1.hide()
	$Select2.hide()
	$Select3.hide()
	$Select4.show()
	$Select5.show()
	$Select6.show()
	select1.emit()
	
func _on_select_2_pressed():
	$Select1.hide()
	$Select2.hide()
	$Select3.hide()
	$Select4.show()
	$Select5.show()
	$Select6.show()
	select2.emit()
	
func _on_select_3_pressed():
	$Select1.hide()
	$Select2.hide()
	$Select3.hide()
	$Select4.show()
	$Select5.show()
	$Select6.show()
	select3.emit()

func _on_pause_button_pressed():
	$Pause_button.hide()
	world.toggle_pause()

func _on_select_4_pressed():
	$Select4.hide()
	$Select5.hide()
	$Select6.hide()
	select4.emit()

func _on_select_5_pressed():	
	$Select4.hide()
	$Select5.hide()
	$Select6.hide()
	select5.emit()

func _on_select_6_pressed():
	$Select4.hide()
	$Select5.hide()
	$Select6.hide()
	select6.emit()
