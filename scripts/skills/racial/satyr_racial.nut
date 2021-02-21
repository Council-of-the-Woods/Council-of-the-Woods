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

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
	}	
});
