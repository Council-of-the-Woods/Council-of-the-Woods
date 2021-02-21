this.pure_spiritual_structure_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.pure_spiritual_structure";
		this.m.Name = "Pure Spiritual Structure";
		this.m.Description = "";
		
		//this icon is a placeholder currently
		this.m.Icon = "status_effect_69.png";
		
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = true;
	}
	
	function onUpdate( _properties )
	{
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
		local count = 0;
		
		foreach (bro in brothers)
		{
			if (bro.getBackground().m.ID == "background.satyr" || bro.getBackground().m.ID == "background.list_more_of_them")
			{
				++count;
			}
		}
		
		local pets = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.PlayerAnimals);
		
		foreach (p in pets)
		{
			if (p.getType() == this.Const.EntityType.ChaoticAnimal || p.getType() == this.Const.EntityType.WIP)
			{
				++count;
			}
		}
		
		_properties.Bravery -= 2 * count;
		_properties.Initiative -= count;
	}
	
});