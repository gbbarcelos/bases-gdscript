class_name Jogador extends CharacterBody3D
#region Nodes
@onready var Apelido: Label3D = %apelido
@onready var Camera: Camera3D = %cam
@onready var Animacao: AnimationPlayer = $animacao
@onready var Interacao_ray: RayCast3D = %interacao_ray
#endregion
@export_group('Movimento')
@export var velocidade: float = 10.0
@export var aceleracao: float = 10.0
@export var vel_rotacao: float = 2.0 ## Velocidade de rotação da câmera.
@export var impulso_externo: float = 15.0 ## Força fixa usada para calcular o empurrão
@export var gravidade: float = -30.0 ## Influência da gravidade.
var fsm: FSM = FSM.new()
var item_em_mao: String = ""
var impulso_total: Vector3 = Vector3.ZERO ## Vetor acumulado do empurrão, aplicado em cada [code]_physics_process[/code].

func _ready() -> void:
	add_child(fsm)

#region Movimentação geral.
func _physics_process(delta: float) -> void:
	movimentacao(delta)

## Controla toda a movimentação.
func movimentacao(delta: float) -> void:
	# Entradas
	var inputs: Vector2 = Input.get_vector('oeste', "leste", "norte", "sul") ## Guarda todas as direções de movimento.
	var correr = Input.is_action_pressed("corrida") and velocity.length() > 8.0 and is_on_floor() ## Condição para a corrida.
	var impulso: bool = Input.is_action_just_pressed("impulso") and is_on_floor() ## Condição para o impulso.
    var interacao = Input.is_action_just_pressed("interagir") and Interacao_ray.is_colliding()
	var alvo = Interacao_ray.get_collider()

	# Direções
	var norte: Vector3 = Camera.global_basis.z
	var direita: Vector3 = Camera.global_basis.x
	var dir: Vector3 = (norte * inputs.y + direita * inputs.x).normalized()
	dir.y = 0.0

	# Gravidade
	var vel_y: float = velocity.y
	velocity.y = 0.0
	velocity.y = vel_y + gravidade * delta

	# Corrida
	var vel_final = dir * velocidade
	if correr:
		aceleracao *= 1.75
    vel_final *= 1.5
	if is_on_floor(): impulso_total = dir * velocidade * 2.5 if impulso else Vector3.ZERO

	# Movimento com impulso somado
	velocity = velocity.move_toward(vel_final + impulso_total, aceleracao * delta)
	# Dissipar o impulso com o tempo
	impulso_total = impulso_total.move_toward(Vector3.ZERO, 20.0 * delta)

	move_and_slide()

	# Interação
	if interacao and alvo and alvo != self:
		var interacoes = {
			"interacao_placeholder": func():
				# fsm.trocar_estado(blablabla)
				pass ,
			"interagir_com_jogador": func():
				# fsm.trocar_estado(blablabla)
				pass ,
		}

		for nome in interacoes.keys():
			if alvo.has_method(nome):
				interacoes[nome].call()
				break

	# Animação
	var inicio_movimento = "CAMINHAR" if velocity.length() > 0.1 else "IDLE"
	var correndo = "CORRER" if correr else inicio_movimento
	var pulando = "PULAR" if not is_on_floor() else correndo

	if inicio_movimento: fsm.trocar_estado(inicio_movimento)
	elif correndo: fsm.trocar_estado(correndo)
	elif pulando: fsm.trocar_estado(pulando)
#endregion

#region Interações
func interacao_placeholder() -> void:
	pass

func interagir_com_jogador() -> void:
	pass
#endregion