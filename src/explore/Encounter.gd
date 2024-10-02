class_name Encounter extends Resource

@export var title: String = ""
@export var graphic_ref: ImageTexture
@export_multiline var description: String = ""
@export var tags: PackedStringArray
@export var challenge_options: Array[Challenge]
