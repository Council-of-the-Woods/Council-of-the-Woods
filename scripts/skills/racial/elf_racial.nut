this.elf_racial <- this.inherit("scripts/skills/skill", {
	m = {
		AlliesAtStart = 0
	},

	function create()
	{
		this.m.ID = "racial.elf";
		this.m.Name = "Elf";
		this.m.Description = "WIP";
		
		//this icon is a placeholder currently
		this.m.Icon = "status_effect_69.png";
		
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = true;
	}

	function onCombatStarted()
	{
		this.m.AlliesAtStart = 0
	}

	function getNumAllies()
	{
		if (!("Entities" in this.Tactical))
		{
			return 0;
		}

		if (this.Tactical.Entities == null)
		{
			return 0;
		}

		if (!this.Tactical.isActive())
		{
			return 0;
		}
		
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local numAllies = 0;

		foreach(ally in allies)
		{
			numAllies++;
		}

		return numAllies;
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood -= 1.0;
		_properties.Vision += 1
		if (this.getContainer().hasSkill("special.night"))
		{
			_properties.Vision += 2;
		}
		_properties.Stamina *= 0.9;
		_properties.Hitpoints *= 0.8;

		local numAlliesDead = this.Math.max(this.m.AlliesAtStart - getNumAllies(), 0);
		_properties.Stamina -= numAlliesDead;
		_properties.MeleeSkill -= numAlliesDead * 2;
		_properties.RangedSkill -= numAlliesDead * 2;

	}
}
