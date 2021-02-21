::mods_registerMod("CotW", 0.1,"Council of the Woods");
::mods_queue(null, null, function()
{
	local gt = this.getroottable()
	gt.Const.CotWMovementAPCost <- [
		0,
		1,
		1,
		2,
		2,
		3,
		3,
		1,
		3
	];

	::mods_hookClass("entity/tactical/player", function (o)
	{
		while(!("fillTalentValues" in o)) o = o[o.SuperName];
		local fillTalentValues = o.fillTalentValues;

		o.fillTalentValues = function()
		{
			fillTalentValues()
			if(this.getBackground() == "background.dryad")
			{
				local dryadTalents = this.new("scripts/mods/talent_customizer");
				//set dryad specific talents
			}
			else if (this.getBackground() == "background.satyr") 
			{
				local satyrTalents = this.new("scripts/mods/talent_customizer");
				satyrTalents.m.PrimaryTalents = [
					this.Const.Attributes.MeleeSkill,
					this.Const.Attributes.HP,
					this.Const.Attributes.Bravery,
					this.Const.Attributes.Fatigue
				];
				satyrTalents.m.PrimaryTalentChances = [5,55];
				satyrTalents.m.NumOfPrimary = [4,4];

				satyrTalents.m.NumOfOther = [0,1];
				satyrTalents.m.OtherTalentChances = [65,35];
				satyrTalents.fillCustomTalentValues(this);
			}
		}
	}
}
