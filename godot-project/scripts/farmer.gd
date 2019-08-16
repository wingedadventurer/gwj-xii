extends Spatial
class_name class_farmer

func has_spotted_unit() -> bool:
	if $unit_detect_area.get_overlapping_areas().size() > 0:
		return true
	return false
