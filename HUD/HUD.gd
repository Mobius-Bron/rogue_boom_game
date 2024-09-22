extends CanvasLayer

signal  start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func show_message(text):
	$Title_Label.text = text
	$Title_Label.show()
	$Title_Label_Timer.start()

func show_game_over():
	show_message("游戏结束")
	await $Title_Label_Timer.timeout
	
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
