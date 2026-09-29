class_name AnimationComponent
extends Node
@export_group("Opcões")
@export var do_centro: bool = true
@export var animacoes_paralelas: bool = true
@export var propriedades: Array = [
	"scale",
	"position",
	"rotation",
	"size",
	"self_modulate"
]
@export_subgroup("Hover settings")
@export var transicao: Tween.TransitionType
@export var duracao: float = 0.1
@export var easing: Tween.EaseType
@export var escala: Vector2 = Vector2(1, 1)
@export var posicao: Vector2
@export var rotacao: float
@export var tamanho: Vector2
@export var modulate: Color = Color.WHITE

var alvo: Control
var escala_padrao: Vector2
var valor_padrao: Dictionary
var hover: Dictionary

func _ready() -> void:
	alvo = get_parent()
	setup()
	conectar_sinais()

func conectar_sinais() -> void:
	alvo.mouse_entered.connect(adicionar_tween.bind(
		hover,
		animacoes_paralelas,
		duracao,
		transicao,
		easing,
	))
	alvo.mouse_exited.connect(adicionar_tween.bind(
		valor_padrao,
		animacoes_paralelas,
		duracao,
		transicao,
		easing,
	))


func get_valores_padrao() -> Dictionary:
	return {
		"scale": alvo.scale,
		"position": alvo.position,
		"rotation": alvo.rotation,
		"size": alvo.size,
		"self_modulate": alvo.self_modulate
	}

func get_valores_hover() -> Dictionary:
	return {
		"scale": escala,
		"position": alvo.position + posicao,
		"rotation": alvo.rotation + deg_to_rad(rotacao),
		"size": alvo.size + tamanho,
		"self_modulate": modulate
	}

func setup() -> void:
	if do_centro:
		alvo.pivot_offset = alvo.size / 2
	escala_padrao = alvo.scale
	valor_padrao = get_valores_padrao()
	hover = get_valores_hover()
	print("VALOR PADRAO:", valor_padrao)

func adicionar_tween(valores: Dictionary, paralela: bool, segundos: float, t: Tween.TransitionType, e: Tween.EaseType) -> void:
	var tween = self.create_tween()
	tween.set_parallel(paralela)
	for propriedade in propriedades:
		tween.tween_property(alvo, str(propriedade), valores[propriedade], segundos).set_trans(t).set_ease(e)
