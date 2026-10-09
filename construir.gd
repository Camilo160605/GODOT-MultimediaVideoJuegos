@tool
extends EditorScript

# true  = solo el Nivel 1 (una Caja en 576, 100)
# false = Nivel 2 (torre de 5 cajas en x = 850)
const SOLO_NIVEL_1 := false

func _run() -> void:
	var root: Node = EditorInterface.get_edited_scene_root()
	if root == null or root.name != "Laboratorio":
		push_error("Abre laboratorio.tscn (raíz Laboratorio) y ejecuta de nuevo.")
		return

	# Limpiar lo que haya
	for hijo in root.get_children():
		root.remove_child(hijo)
		hijo.queue_free()

	_crear_piso(root)

	if SOLO_NIVEL_1:
		_crear_caja(root, "Caja", Vector2(576, 100))
	else:
		_crear_caja(root, "Caja", Vector2(850, 548))
		_crear_caja(root, "Caja2", Vector2(850, 484))
		_crear_caja(root, "Caja3", Vector2(850, 420))
		_crear_caja(root, "Caja4", Vector2(850, 356))
		_crear_caja(root, "Caja5", Vector2(850, 292))

	print("Escena construida. Pulsa Ctrl+S para guardar.")


func _crear_piso(root: Node) -> void:
	var piso := StaticBody2D.new()
	piso.name = "Piso"
	piso.position = Vector2(576, 600)
	root.add_child(piso)
	piso.owner = root

	var forma := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	forma.shape = rect
	piso.add_child(forma)
	forma.owner = root

	var color := ColorRect.new()
	color.color = Color(0.25, 0.12, 0.02)  # café oscuro
	color.size = Vector2(1000, 40)
	color.position = Vector2(-500, -20)
	piso.add_child(color)
	color.owner = root


func _crear_caja(root: Node, nombre: String, pos: Vector2) -> void:
	var caja := RigidBody2D.new()
	caja.name = nombre
	caja.position = pos
	root.add_child(caja)
	caja.owner = root

	var sprite := Sprite2D.new()
	sprite.texture = load("res://icon.svg")
	sprite.scale = Vector2(0.5, 0.5)
	caja.add_child(sprite)
	sprite.owner = root

	var forma := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(64, 64)
	forma.shape = rect
	caja.add_child(forma)
	forma.owner = root
