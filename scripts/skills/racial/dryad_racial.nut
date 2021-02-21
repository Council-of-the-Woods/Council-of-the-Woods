this.dryad_racial <- this.inherit("scripts/skills/skill", {
	m = {
		KillCount = 0
	},
	function create()
	{
		this.m.ID = "racial.dryad";
		this.m.Name = "Pristine Being";
		this.m.Description = "WIP";
		
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
		//debuff when kill someone in battle 
		_properties.Bravery -= this.m.KillCount * 5;
		_properties.Initiative -= this.m.KillCount;
	}
	
	function onTargetKilled( _targetEntity, _skill )
	{
		++this.m.KillCount;
	}
	
	function onTurnStart()
	{
		//health regen each turn
		local actor = this.getContainer().getActor()
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + 3);
	}
	
	function onCombatStarted()
	{
		this.m.KillCount = 0;
	}
	
	function onCombatFinished()
	{
		this.m.KillCount = 0;
	}
	
});