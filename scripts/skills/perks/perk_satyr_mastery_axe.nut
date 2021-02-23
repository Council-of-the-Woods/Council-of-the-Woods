this.perk_satyer_mastery_axe <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.satyer_mastery_axe";
		
		//currently is a placeholder, this perk name is "The Wild Axemen"
		this.m.Name = this.Const.Strings.PerkName.Adrenaline;
		this.m.Description = this.Const.Strings.PerkDescription.Adrenaline;
		this.m.Icon = "ui/perks/perk_61.png";
		//
		
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInAxes = true;
	}

});

