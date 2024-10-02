class_name Challenge extends Resource

@export var title: String = ""
@export var icon_ref: ImageTexture
@export var graphic_ref: ImageTexture
@export_multiline var description: String = ""
@export var tags: PackedStringArray
@export var calculated_stat_cost: Array[int]
@export var stat_costs: Array[StatCost]
