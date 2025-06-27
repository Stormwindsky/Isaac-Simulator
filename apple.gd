extends CharacterBody2D
class_name Apple

# Paramètres
@export var fall_speed: float = 200
var clone_timer: float = 0.0
var clone_interval: float = randf_range(1.0, 2.0)
var player: CharacterBody2D = null
var is_clone: bool = false

# Références aux nœuds enfants
@onready var sprite = $Sprite2D
@onready var collider = $Sprite2D/CollisionShape2D  # ← Doit correspondre au nom exact dans la scène !

func _ready():
	randomize()
	player = get_node("../Player")  # NE PAS CHANGER
	
	if player == null:
		printerr("ERREUR : Le joueur 'Player' n'a pas été trouvé ! Vérifie le nom et le chemin.")
	
	if is_clone:
		spawn_as_clone()
	else:
		position = Vector2(-100, -100)  # Position invisible initiale pour l’original

func spawn_as_clone():
	position.x = player.position.x  # Même position X que joueur
	position.y = -50  # Tombe du haut de l’écran
	is_clone = true

func _physics_process(delta):
	if not is_clone:
		handle_cloning(delta)
		return
	
	# Appliquer le mouvement vers le bas
	velocity.y = fall_speed
	
	# Déplacement avec détection de collision
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() == player:
			get_tree().change_scene_to_file("res://Main.tscn")  # Redirection vers la scène Main
	
	# Supprimer le clone s’il est en dehors de l’écran
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func handle_cloning(delta):
	clone_timer += delta
	if clone_timer >= clone_interval:
		create_clone()
		clone_timer = 0
		clone_interval = randf_range(1.0, 2.0)

func create_clone():
	if player == null:
		return
	
	var new_clone = duplicate()
	new_clone.is_clone = true
	new_clone.position = Vector2(player.position.x, -50)
	get_parent().call_deferred("add_child", new_clone)
