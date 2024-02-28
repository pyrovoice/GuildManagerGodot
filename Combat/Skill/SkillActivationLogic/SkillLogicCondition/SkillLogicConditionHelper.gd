extends Object
class_name SkillLogicConditionHelper

func _init():
	printerr("SkillLogicConditionHelper should not be instantiated")
	
static func getGenericComparisonOptionButton(valueToUpdate) -> OptionButton:
	var o: OptionButton = preload("uid://54v0t8e7ulmy").instantiate()
	o.item_selected.connect(func(index): valueToUpdate = o.get_item_text(index))
	return o

static func getGenericPercentOrValueButton(isPercent, spinBoxToUpdate: SpinBox = null) -> OptionButton:
	var optionButton: OptionButton = preload("uid://dykoba3hq5p07").instantiate()
	optionButton.item_selected.connect(func(index): 
		isPercent = index == 1
		if spinBoxToUpdate:
			if isPercent:
				spinBoxToUpdate.suffix = "%"
				spinBoxToUpdate.max_value = 100
			else:
				spinBoxToUpdate.suffix = ""
				spinBoxToUpdate.max_value = 10000
		)
	return optionButton

static func getGenericSpinbox(valueToUpdate) -> SpinBox:
	var spinBox: SpinBox = preload("uid://bqumbpu76jt42").instantiate()
	spinBox.value_changed.connect(func(val): valueToUpdate = val)
	return spinBox

static func getGenericAttributeDropdown(valueToUpdate) -> OptionButton:
	var optionButton: OptionButton = preload("uid://rf2j5si6p2fg").instantiate()
	for att in CombatAttributeEnum.att.keys():
		optionButton.add_item(att)
	optionButton.item_selected.connect(func(index): 
		valueToUpdate = CombatAttributeEnum.getAttributeFromString(optionButton.get_item_text(index))
		print(valueToUpdate))
	return optionButton

static func getGenericPositionDropdown(valueToUpdate) -> OptionButton:
	var optionButton: OptionButton = preload("uid://cgo6iki0hwxwd").instantiate()
	optionButton.item_selected.connect(func(index): valueToUpdate = index)
	return optionButton
