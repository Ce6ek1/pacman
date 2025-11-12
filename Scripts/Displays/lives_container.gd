extends HBoxContainer

@onready var pacman: Node2D = $"../../../Map/PacMan"
@export var texture: Texture2D = preload('res://Sprites/PacMan/PacMan02.png')


func _ready():
	for i in GameState.lives:
		var sprite: TextureRect = TextureRect.new()
		sprite.texture = texture
		add_child(sprite)

func delete_one_live_sprite():
	var _child = get_child(-1)
	for i in range(4):
		_child.visible = false
		await get_tree().create_timer(0.25).timeout
		_child.visible = true
		await get_tree().create_timer(0.25).timeout
	get_child(-1).queue_free()
