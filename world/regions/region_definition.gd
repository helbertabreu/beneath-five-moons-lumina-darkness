## Define a configuração estática e os parâmetros de uma Região do Mundo em Quintalia.
##
## Armazena metadados da região, nível de perigo, clima padrão, perfil de iluminação
## e o caminho do arquivo de cena (.tscn) associado para streaming.

class_name RegionDefinition
extends Resource

## Identificador único da região (ex: &"region.port_astraea", &"region.dark_sector")
@export var region_id: StringName = &"region.default"

## Nome visível da região exibido na UI
@export var display_name: String = "Região Desconhecida"

## Caminho do arquivo de cena da região (.tscn)
@export_file("*.tscn") var scene_path: String = ""

## Nível de perigo da região (0 = Segura, 1 = Selvagem, 2 = Perigosa, 3 = Setor Escuro)
@export_range(0, 3) var danger_level: int = 0

## Perfil de iluminação base da região (0.0 = Escuridão Absoluta, 1.0 = Luz Plena)
@export_range(0.0, 1.0) var default_light_level: float = 1.0

## Taxa de regeneração de recursos durante simulação offline (multiplicador)
@export var offline_regeneration_rate: float = 1.0
