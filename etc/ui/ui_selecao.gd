class_name BotoesSelecao
extends PanelContainer
var botoes := [] ## Lista de botões de seleção
var selecionado := null ## Botão atualmente selecionado
var callback_selecao: Callable = null ## Função a ser chamada quando um botão é selecionado
var callback_desselecao: Callable = null ## Função a ser chamada quando um botão é desselecionado

## Função estática para configurar e instanciar o nó em outra cena, além de definir os callbacks
static func configurar(callback_selecao: Callable, callback_desselecao: Callable = null) -> BotoesSelecao:
    var novo: BotoesSelecao = preload("uid://ckr532ufi60s5").instantiate() as BotoesSelecao
    novo.callback_selecao = callback_selecao
    novo.callback_desselecao = callback_desselecao
    return novo

func _ready() -> void:
    for botao in get_node("VBoxContainer").get_children():
        if botao is Button:
            botoes.append(botao)
            botao.pressed.connect(func(b=botao) -> void: selecionar(b))
    esconder()

func selecionar(botao: Button) -> void:
    if selecionado == botao: ## Se o botão já está selecionado, não faz nada
        return
    
    if selecionado != null:
        selecionado.pressed = false
        if callback_desselecao != null:
            callback_desselecao.call(selecionado)
    selecionado = botao

    if callback_selecao != null:
        callback_selecao.call(selecionado)

func resetar_botoes() -> void:
    for botao in botoes:
        botao.pressed = false
    selecionado = null

func esconder() -> void:
    visible = false
    resetar_botoes()

func mostrar() -> void:
    visible = true
    resetar_botoes()