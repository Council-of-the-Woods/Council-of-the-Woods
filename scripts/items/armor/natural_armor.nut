this.natural_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.natural_armor";
		this.m.Name = "Natural Armor";
		this.m.Description = "The natural armor of a satyr";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.Variant = 10;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 0;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = 0;
	}
});
