this.perk_the_herd <- this.inherit("scripts/skills/skill", {
	m = {
		IsOnStartingYourTurn = false
	},
	function create()
	{
		this.m.ID = "perk.the_herd";
		
		//currently is a placeholder, this perk name is "For The Herd"
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
			_properties.ActionPoints += 1;
			_properties.MeleeSkill += 10;
			_properties.Initiative += 15;
			actor.setActionPoints(_properties.ActionPoints);
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
		
		_properties.Hitpoints += 2 * satyrs;
		_properties.MeleeDefense += satyrs;
		_properties.HitpointsMult *= 1.05;
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_attacker.getSkills().hasSkill("effects.spearwall"))
		{
			return;
		}
		
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.m.Container.getActor().getID())
		{
			return;
		}

		if (_skill.getID() == "actives.thrust" || _skill.getID() == "actives.prong")
		{
			_properties.DamageReceivedMeleeMult *= 1.15;
		}
	}

});

