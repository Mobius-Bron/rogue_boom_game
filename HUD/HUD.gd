extends CanvasLayer

signal  start_game
# Called when the node enters the scene tree for the first time.
@export var player:CharacterBody2D
var Wave_Number=0

func _ready():
	pass
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
	$Select_Screen/Select1.hide()
	$Select_Screen/Select2.hide()
	$Select_Screen/Select3.hide()
	
func _on_select_2_pressed():
	$Select_Screen/Select1.hide()
	$Select_Screen/Select2.hide()
	$Select_Screen/Select3.hide()

func _on_select_3_pressed():
	$Select_Screen/Select1.hide()
	$Select_Screen/Select2.hide()
	$Select_Screen/Select3.hide()
