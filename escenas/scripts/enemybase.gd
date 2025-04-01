extends CharacterBody2D

@export var speed: float = 35.0
@export var health: int = 100
@export var gold_reward: int = 50

var agent: NavigationAgent2D
var destination: Area2D

func _ready():
	# Obtener el agente de navegación
	agent = $NavigationAgent2D  

	# Buscar el nodo "MEta"
	destination = get_tree().root.get_node("Game/Area2D(Meta)")  # Asegúrate de que la ruta sea correcta
	
	if destination == null:
		print("¡No se encontró el nodo Meta!")
		return
	
	# Definir el destino para el agente de navegación
	agent.target_position = destination.position

func _process(delta):
	if health > 0:
		# Obtener la siguiente posición en el camino
		var next_position = agent.get_next_path_position()
		
		if next_position != Vector2.ZERO:
			# Calcular la dirección hacia la siguiente posición
			var direction = (next_position - global_position).normalized()
			
			# Establecer la velocidad del enemigo
			velocity = direction * speed
			move_and_slide()
		else:
			# Si no hay más posiciones en el camino, el enemigo ha llegado al destino
			_reached_goal()

func _reached_goal():
	# Si el enemigo llegó a la meta, se elimina (puedes restar vida al jugador aquí)
	queue_free()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		_die()

func _die():
	print("Oro obtenido: ", gold_reward)
	queue_free()
