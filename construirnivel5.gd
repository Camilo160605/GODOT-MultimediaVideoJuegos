@tool
extends EditorScript

# Cambia entre "Replace" y "Combine" y vuelve a ejecutar para cada prueba
const MODO := "Replace"

func _run() -> void:
	var root: Node = EditorInterface.get_edited_scene_root()
	if root == null or root.name != "Laboratorio":
		push_error("Abre nivel5.tscn (raíz Laboratorio) y ejecuta de nuevo.")
		return
	if root.get_node_or_null("Peso") == null or root.get_node_or_null("PinJoint2D") == null:
		push_warning("No encuentro Peso o PinJoint2D: ¿es la copia del nivel 4?")

	# Quitar lo de una ejecución anterior (no toca el resto de la escena)
	for nombre in ["Camera2D", "ZonaAntigravedad", "CajaFlotante"]:
		var viejo := root.get_node_or_null(nombre)
		if viejo:
			root.remove_child(viejo)
			viejo.queue_free()

	_crear_camara(root)
	_crear_zona(root)
	_crear_caja_flotante(root)
	print("Nivel 5 listo (modo ", MODO, "). Guarda con Ctrl+S y prueba con F6.")


func _crear_camara(root: Node) -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = Vector2(576, 324)
	cam.zoom = Vector2(0.8, 0.8)
	root.add_child(cam)
	cam.owner = root


func _crear_zona(root: Node) -> void:
	var zona := Area2D.new()
	zona.name = "ZonaAntigravedad"
	zona.position = Vector2(990, 400)
	if MODO == "Replace":
		zona.gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
		zona.gravity_direction = Vector2(0, -1)
		zona.gravity = 400.0
	else:
		zona.gravity_space_override = Area2D.SPACE_OVERRIDE_COMBINE
		zona.gravity_direction = Vector2(1, 0)
		zona.gravity = 1500.0
	root.add_child(zona)
	zona.owner = root

	var forma := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(160, 300)
	forma.shape = rect
	zona.add_child(forma)
	forma.owner = root

	var color := ColorRect.new()
	color.color = Color(0.4, 1.0, 0.4, 0.35)  # verde claro semitransparente
	color.size = Vector2(160, 300)
	color.position = Vector2(-80, -150)
	zona.add_child(color)
	color.owner = root


func _crear_caja_flotante(root: Node) -> void:
	var caja := RigidBody2D.new()
	caja.name = "CajaFlotante"
	caja.position = Vector2(990, 320)
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
