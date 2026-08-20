## ServiceRegistry.gd
## Autoload responsável pela localização e injeção centralizada de serviços.
##
## Impede a criação de múltiplos Autoloads desnecessários no project.godot,
## permitindo que sistemas de gameplay obtenham referências a serviços desacoplados.

extends Node

## Dicionário interno contendo os serviços registrados em tempo de execução.
## Chave: StringName (ex: &"TimeService"), Valor: Object/RefCounted
var _services: Dictionary = {}


## Registra uma instância de serviço no localizador global.
## Returns: True se registrado com sucesso, False se já existia um registro com o mesmo nome.
func register_service(service_name: StringName, service_instance: Object) -> bool:
	if _services.has(service_name):
		push_warning("ServiceRegistry: O serviço '%s' já está registrado. Substituição negada." % service_name)
		return false
	
	_services[service_name] = service_instance
	print("[ServiceRegistry] Serviço registrado: ", service_name)
	return true


## Remove o registro de um serviço existente.
func unregister_service(service_name: StringName) -> void:
	if _services.has(service_name):
		_services.erase(service_name)
		print("[ServiceRegistry] Serviço removido: ", service_name)


## Retorna o serviço registrado pelo nome. Retorna null se não for encontrado.
func get_service(service_name: StringName) -> Object:
	if not _services.has(service_name):
		push_error("ServiceRegistry: Serviço '%s' não foi encontrado." % service_name)
		return null
	return _services[service_name]


## Verifica se um serviço está atualmente registrado.
func has_service(service_name: StringName) -> bool:
	return _services.has(service_name)


## Limpa todos os serviços registrados (útil para testes unitários ou reset de jogo).
func clear_all_services() -> void:
	_services.clear()
	print("[ServiceRegistry] Todos os serviços foram limpos.")
