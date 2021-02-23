this.perk_veteran_hunter <- this.inherit("scripts/skills/skill", {
	m = {
		IsOnStartingYourTurn = false
	},
	function create()
	{
		this.m.ID = "perk.veteran_hunter";
		
		//currently is a placeholder, this perk name is "...Yet still, a Veteran of the Hunt"
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
		local BonusAP = 0;
		
		if (!actor.isPlacedOnMap())
		{
			return;
		}
		
		if (actor.getInitiative() >= 120)
		{
			++BonusAP;
		}
		
		if (actor.getArmor(this.Const.BodyPart.Body) >= 200)
		{
			++BonusAP;
		}
		
		if (actor.getCurrentProperties().MeleeSkill <= 70)
		{
			++BonusAP;
		}
		
		if (BonusAP != 0)
		{
			_properties.ActionPoints += BonusAP;
			
			if (this.m.IsOnStartingYourTurn)
			{
				actor.setActionPoints(_properties.ActionPoints);
				this.m.IsOnStartingYourTurn = false;
			}
		}
	}
	
	function onTurnStart()
	{
		this.m.IsOnStartingYourTurn = true;
		this.m.Container.update();
	}

});

