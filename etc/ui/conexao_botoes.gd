class_name ConectarBotoes
extends Node
static var sinais_por_tipo := { ## Dicionário: Tipo → Lista de sinais a serem conectados
	"Button": ["pressed"],
	"CheckBox": ["toggled"],
	"OptionButton": ["item_selected"],
	"SpinBox": ["value_changed"],
	"Slider": ["value_changed"],
	"LineEdit": ["text_submitted", "text_changed"],
	"TextEdit": ["text_changed"],
	"ColorPicker": ["color_changed"],
	"FileDialog": ["file_selected"],
	"ItemList": ["item_activated"],
	"MenuButton": ["about_to_popup"],
	}

## Conecta os sinais dos botões e outros controles a um método específico.
static func conectar_botoes(raiz: Node, metodo: Callable) -> void:
	_conectar_recursivo(raiz, metodo)

## Função recursiva para conectar sinais em todos os nós filhos.
static func _conectar_recursivo(no: Node, metodo: Callable) -> void:
    # Itera sobre todos os filhos do nó atual.
		for filho in no.get_children():
			var tipo : String = filho.get_class() # Obtém o tipo do filho atual.
			if sinais_por_tipo.has(tipo): # Se o tipo do filho está no dicionário
				for sinal in sinais_por_tipo[tipo]:
					# Verifica se o sinal realmente existe no objeto (caso tenha herança ou sobrescrita)
					if filho.has_signal(sinal) and not filho.is_connected(sinal, metodo):
						filho.connect(sinal, metodo.bind(filho, sinal))
			# Continua a busca recursiva nos filhos.
			if filho.get_child_count() > 0:
				_conectar_recursivo(filho, metodo)

# Exemplo de uso:
# ConectarBotoes.conectar_botoes(self, Callable(self, "receptores_config"))
# Onde "receptores_config" é o método que receberá os sinais.
# O método deve ter a seguinte assinatura:
# func receptores_config(no: Node, sinal: String) -> void:
#     match [no.name, sinal]:
#         ["botao_exemplo", "pressed"]:
#             print("Botão pressionado!")
#         ["checkbox_exemplo", "toggled"]:
#             print("Checkbox alterado!")