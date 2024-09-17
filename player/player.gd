extends CharacterBody2D


const SPEED = 200.0


@export var max_health:TextureProgressBar
@export var speed=400
var screen_size
var current_health


func _ready():
	screen_size=get_viewport_rect().size


func _physics_process(delta):
	var velocity=Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1		
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
		
	if velocity.length()>0:
		velocity=velocity.normalized()*speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play()
	
	position +=velocity*delta
	position =position.clamp(Vector2.ZERO,screen_size)
	

	if velocity.x !=0 or velocity.y !=0:
		$AnimatedSprite2D.animation="walk"	
		$AnimatedSprite2D.flip_v=false
		$AnimatedSprite2D.flip_h=velocity.x >0
	elif velocity.x ==0 and velocity.y ==0:
		$AnimatedSprite2D.animation="stay"
