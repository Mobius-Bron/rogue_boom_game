extends Node2D

var isable = true
var atk = 1

@onready var tilemap = $TileMap
@onready var timeLabel = $Label

@onready var cx = $wave_area/cx
@onready var cy = $wave_area/cy

var layer: int = 0
@export var length: int = 3
@export var boom_time = 3

var wave_list = [2,0,1,2,3]
var nextTargets = []
var enemyList = []

func _ready():
	cx.scale.x = length + length + 1
	cy.scale.y = length + length + 1
	length += 1
	await get_tree().create_timer(boom_time).timeout
	boom_()

func _process(_delta):
	timeLabel.text = str(int(boom_time)+1)
	boom_time -= _delta
	pass
		
func boom_():
	if not isable:
		return
	isable = false
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
		i.hurt(atk)
	
	self.queue_free()

func _on_wave_area_area_entered(area):
	if area.name == "boom_area":
		var node = area.get_parent()
		if node != self:
			nextTargets.append(node)
	elif  area.name == "hurt_area":
		var node = area.get_parent()
		if node not in enemyList:
			enemyList.append(node)
	elif  area.name == "player_hurt_area":
		var node = area.get_parent()
		if node not in enemyList:
			enemyList.append(node)

func _on_wave_area_area_exited(area):
	if area.name == "boom_area":
		var node = area.get_parent()
		if node != self:
			nextTargets.erase(node)
	elif  area.name == "hunt_area":
		var node = area.get_parent()
		if node in enemyList:
			enemyList.erase(node)
	elif  area.name == "player_hunt_area":
		var node = area.get_parent()
		if node in enemyList:
			enemyList.erase(node)
