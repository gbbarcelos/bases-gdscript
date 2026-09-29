extends PanelContainer
@onready var texto: RichTextLabel = %texto
const OFFSET: Vector2 = Vector2.ONE * 60
var tween_opacidade: Tween = null

func _ready():
    hide()
func _input(event: InputEvent):
    if visible and event is InputEventMouseMotion:
        global_position = get_global_mouse_position() + OFFSET

func toggle(on: bool, t: String):
    if on:
        show()
        modulate.a = 0.0
        opacidade_tween(1.0)
        texto.text = t
    else:
        modulate.a = 1.0
        await opacidade_tween(0.0).finished
        texto.text = ""
        hide()

func opacidade_tween(to: float):
    if tween_opacidade: tween_opacidade.kill()
    tween_opacidade = get_tree().create_tween()
    tween_opacidade.tween_property(self, 'modulate.a', to, 0.3)
    return opacidade_tween

## Exemplo de uso (é usado no node que usa esse tooltip):
## mouse_entered.connect(xxxx)
## func xxxx():
## tooltip.toggle(true, "textoxxxxx")
## mouse_exited também