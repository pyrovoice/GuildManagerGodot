extends SkillConditionParameter
class_name SkillConditionParameterValue

func createNode() -> Node:
	return OptionButton.new()
	
func getFollowingRequiredParameters() -> Array[SkillConditionParameter]:
	return []

