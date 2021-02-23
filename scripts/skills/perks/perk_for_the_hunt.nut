this.perk_for_the_hunt <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.for_the_hunt";
		
		//currently is a placeholder, this perk name is "For the Hunt!"
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
		local actor = this.m.Container.getActor();
		
		if (actor.isPlacedOnMap() && this.Time.getRound() <= 1)
		{
			_properties.DamageTotalMult *= 1.2;
			_properties.RangedDefense += 15;
		}
		
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local satyrs = 0;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getSkills().hasSkill("racial.satyr"))
			{
				++satyrs;
			}
		}
		
		_properties.MeleeSkill += satyrs;
	}

});

