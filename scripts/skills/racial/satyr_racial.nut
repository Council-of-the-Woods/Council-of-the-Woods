this.satyr_racial <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "racial.satyr";
		this.m.Name = "Satyr";
		this.m.Description = "WIP";
		
		//this icon is a placeholder currently
		this.m.Icon = "status_effect_69.png";
		
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + 5);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local enemies = this.Tactical.Entities.getInstancesOfFaction(!actor.getFaction());
		local numEnemies = 0;
		foreach(enemy in enemies)
		{
			numEnemies++;
		}
		_properties.Initiative += numEnemies;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= 0.9;

		if(_hitInfo.BodyPart == this.Const.BodyPart.Head)
		{
			r = this.Math.rand(1,20);
			if (r == 1) 
			{
			    _properties.DamageReceivedRegularMult = 0.0; //Not sure about this implementation with regards to injuries etc
			    this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s horns protected them!");
			}
		}
	}
});
