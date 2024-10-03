class_name Challenge extends Resource

@export var title: String = ""
@export var icon_ref: ImageTexture
@export var graphic_ref: ImageTexture
@export_multiline var description: String = ""
@export var tags: PackedStringArray
@export var calculated_stat_cost: Array[int]
@export var stat_costs: Array[StatCost]:
    set(value):
        stat_costs = value
        calculated_stat_cost = []
        for i in range(stat_costs.size()):
            var final_cost: int = 0
            if stat_costs[i] != null:
                final_cost += stat_costs[i].static_cost
                for roll in stat_costs[i].rolls:
                    final_cost += randi_range(1, roll)
            calculated_stat_cost.append(final_cost)
