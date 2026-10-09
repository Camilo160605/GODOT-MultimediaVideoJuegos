@tool
extends EditorScript

func _run() -> void:
	var root: Node = EditorInterface.get_edited_scene_root()
	if root == null or root.name != "Laboratorio3D":
		push_error("Abre lab3d.tscn (raíz Laboratorio3D) y ejecuta de nuevo.")
		return

	# Limpiar lo que haya
	for hijo in root.get_children():
		root.remove_child(hijo)
		hijo.queue_free()

	# Piso
	var piso := StaticBody3D.new()
	piso.name = "Piso"
	_agregar(root, root, piso)

	var piso_forma := CollisionShape3D.new()
	var piso_box := BoxShape3D.new()
	piso_box.size = Vector3(10, 0.5, 10)
	piso_forma.shape = piso_box
	_agregar(root, piso, piso_forma)

	var piso_malla := MeshInstance3D.new()
	var piso_mesh := BoxMesh.new()
	piso_mesh.size = Vector3(10, 0.5, 10)
	piso_malla.mesh = piso_mesh
	_agregar(root, piso, piso_malla)

	# Cubo
	var cubo := RigidBody3D.new()
	cubo.name = "Cubo"
	cubo.position = Vector3(0, 4, 0)
	cubo.rotation_degrees = Vector3(20, 0, 30)
	_agregar(root, root, cubo)

	var cubo_forma := CollisionShape3D.new()
	cubo_forma.shape = BoxShape3D.new()  # Size (1, 1, 1) por defecto
	_agregar(root, cubo, cubo_forma)

	var cubo_malla := MeshInstance3D.new()
	cubo_malla.mesh = BoxMesh.new()      # Size (1, 1, 1) por defecto
	_agregar(root, cubo, cubo_malla)

	# Luz direccional con sombra
	var luz := DirectionalLight3D.new()
	luz.name = "DirectionalLight3D"
	luz.rotation_degrees = Vector3(-45, 30, 0)
	luz.shadow_enabled = true
	_agregar(root, root, luz)

	# Cámara
	var cam := Camera3D.new()
	cam.name = "Camera3D"
	cam.position = Vector3(0, 3, 8)
	cam.rotation_degrees = Vector3(-15, 0, 0)
	_agregar(root, root, cam)

	print("Escena 3D lista. Guarda con Ctrl+S y prueba con F6.")


func _agregar(root: Node, padre: Node, hijo: Node) -> void:
	padre.add_child(hijo)
	hijo.owner = root
