this.natural_armor_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.head.natural_armor_helmet";
		this.m.Name = "Natural Armor";
		this.m.Description = "The natural headgear of a satyr";
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
		this.m.Condition = 20;
		this.m.ConditionMax = 20;
		this.m.StaminaModifier = 0;
	}
});
