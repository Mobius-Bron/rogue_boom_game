extends CharacterBody2D


const SPEED = 200.0


#@export var max_health:TextureProgressBar
@export var max_health = 100
var current_health = max_health
@export var speed=400
@onready var health_bar = $health_bar

func _ready():
	$AnimatedSprite2D.play()
	health_bar.max_value=max_health
	health_bar.value=current_health
	
func _physics_process(_delta):
	if velocity.x !=0 or velocity.y !=0:	
		$AnimatedSprite2D.flip_v=false
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h=true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h=false
	elif velocity.x ==0 and velocity.y ==0:
		$AnimatedSprite2D.animation="stay"
	#if current_health>0:
	move()

func hurt(_atk):
	if current_health>0:	
		current_health -= _atk
	else:
		current_health=-1
	health_bar.value=current_health

func start(pos):
	position=pos
	show()
	$CollisionShape2D.disabled=false
	
func show_game_over():
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("dead")
	
func move():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		$AnimatedSprite2D.animation="walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		$AnimatedSprite2D.animation="stay"

	move_and_slide()
