this.perk_bigger_horns <- this.inherit("scripts/skills/skill", {
	m = {
		CurrentAlly = 0,
		IsBerserking = false
	},
	function create()
	{
		this.m.ID = "perk.bigger_horns";
		
		//currently is a placeholder, this perk name is "Bigger Horns mean bigger bones"
		this.m.Name = this.Const.Strings.PerkName.Adrenaline;
		this.m.Description = this.Const.Strings.PerkDescription.Adrenaline;
		this.m.Icon = "ui/perks/perk_61.png";
		this.m.IconMini = "perk_61_mini";
		//
		
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Melee Damage"
			}
		];
		
		if (this.m.CurrentAlly != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.CurrentAlly * 2 + "[/color] Resolve form nearby allies satyrs"
			});
		}
		
		if (this.m.IsBerserking)
		{
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Melee Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Ranged Defense"
				}
			]);
		
		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.m.IsHidden = true;
			this.m.IsBerserking = false;
			return;
		}

		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local satyrs = 0;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getTile().getDistanceTo(myTile) <= 3 && ally.getSkills().hasSkill("racial.satyr"))
			{
				++satyrs;
				
			}
		}
		
		this.m.IsBerserking = false;
		this.m.CurrentAlly = satyrs;
		
		_properties.MeleeDamageMult += 0.1;
		_properties.Bravery += 2 * satyrs;
		
		if (actor.getHitpoints() <= actor.getHitpointsMax() * 0.3)
		{
			this.m.IsBerserking = true;
			_properties.RangedDefense += 20;
			_properties.MeleeDefense += 20;
		}
	}
	
	function onCombatStarted()
	{
		this.m.IsBerserking = false;
		this.m.IsHidden = false;
	}
	
	function onCombatFinished()
	{
		this.m.IsBerserking = false;
		this.m.IsHidden = true;
	}

});

