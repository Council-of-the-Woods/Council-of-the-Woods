this.perk_love_scars <- this.inherit("scripts/skills/skill", {
	m = {
		CurrentInjuries = 0,
		Temporary = 0,
		Permanent = 0,
		TurnLefts = 0
	},
	function create()
	{
		this.m.ID = "perk.love_scars";
		
		//currently is a placeholder, this perk name is "Scars are the real prize"
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
				icon = "ui/icons/damage_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Threshold to Receive Injury"
			}
		];
		
		if (this.m.Temporary != 0 || this.m.Permanent != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (2 * this.m.Permanent + 3 * this.m.Temporary) + "[/color] Bonus Damage"
			});
		
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (3 * this.m.Permanent + 3 * this.m.Temporary) + "[/color] Resolve"
			});
		}
		
		if (this.m.TurnLefts != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Not affected by non-permanent injuries for [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnLefts + "[/color] turns left"
			});
		
		return ret;
	}

	function onUpdate( _properties )
	{
		local injuries = this.m.Container.getAllSkillsOfType(this.Const.SkillType.Injury);
		this.m.Temporary = this.m.Container.getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len();
		this.m.Permanent = this.m.Container.getAllSkillsOfType(this.Const.SkillType.PermanentInjury).len();
		
		_properties.ThresholdToReceiveInjuryMult = 1.1;
		
		if (injuries.len() < this.m.Temporary + this.m.Permanent)
		{
			return;
		}
		
		_properties.Bravery += 3 * this.m.Permanent + 3 * this.m.Temporary;
		
		if (injuries.len() > this.m.CurrentInjuries)
		{
			this.m.TurnLefts = 2;
			this.m.CurrentInjuries = injuries.len();
		}
		
		if (this.m.TurnLefts != 0)
		{
			_properties.IsAffectedByInjuries = false;
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.DamageRegularMin += 2 * this.m.Permanent + 3 * this.m.Temporary;
		_properties.DamageRegularMax += 2 * this.m.Permanent + 3 * this.m.Temporary;
	}
	
	function onTurnStart()
	{
		this.m.TurnLefts = this.Math.max(0, this.m.TurnLefts - 1);
	}
	
	function onCombatStarted()
	{
		this.m.IsHidden = false;
	}
	
	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});

