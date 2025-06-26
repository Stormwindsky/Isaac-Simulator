extends Sprite2D

class_name FallingItem

# Paramètres
var fall_speed: float = 200
var clone_timer: float = 0.0
var clone_interval: float = randf_range(1, 2)
var player: CharacterBody2D = null
var is_clone: bool = false
var hitbox: Area2D  # Pour détecter les collisions

func _ready():
	randomize()
	# Configuration de la hitbox
	hitbox = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = Vector2(texture.get_width() / 2, texture.get_height() / 2)
	hitbox.add_child(collision)
	add_child(hitbox)
	
	hitbox.body_entered.connect(_on_body_entered)
	
	if is_clone:
		position.x = randf_range(50, get_viewport_rect().size.x - 50)
		position.y = -50
	else:
		position = Vector2(-100, -100)
	
	player = get_node("../CharacterBody2D")
	if player == null:
		printerr("Joueur non trouvé!")

func _on_body_entered(body: Node):
	if is_clone and body == player:
		get_tree().change_scene_to_file("res://main.tscn")

func _process(delta):
	if is_clone:
		position.y += fall_speed * delta
		if position.y > get_viewport_rect().size.y + 100:
			queue_free()
	else:
		handle_cloning(delta)

func handle_cloning(delta):
	clone_timer += delta
	if clone_timer >= clone_interval:
		create_clone()
		clone_timer = 0
		clone_interval = randf_range(1, 2)

func create_clone():
	if player == null:
		return
	
	var new_clone = duplicate()
	new_clone.position = Vector2(player.position.x, -50)
	new_clone.is_clone = true
	get_parent().call_deferred("add_child", new_clone)
