extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connecte le signal 'pressed' du bouton à la fonction _on_button_pressed
	self.pressed.connect(_on_button_pressed)

# Fonction appelée quand le bouton est pressé
func _on_button_pressed():
	# Charge et change la scène vers main.tscn
	get_tree().change_scene_to_file("res://main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
