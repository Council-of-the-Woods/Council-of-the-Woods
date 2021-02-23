::mods_registerMod("CotW", 0.1,"Council of the Woods");
::mods_queue(null, null, function()
{
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
					this.Const.Attributes.Hitpoints,
					this.Const.Attributes.Bravery,
					this.Const.Attributes.Fatigue
				];
				satyrTalents.m.PrimaryTalentChances = [5,55];
				satyrTalents.m.NumOfPrimary = [4,4];

				satyrTalents.m.NumOfOther = [0,1];
				satyrTalents.m.OtherTalentChances = [65,35];
				satyrTalents.fillCustomTalentValues(this);
			}
			else if (this.getBackground() == "background.elf")
			{
				local elfTalents = this.new("scripts/mods/talent_customizer");
				//set elf specific talents
			}
		}

		local checkMorale = o.checkMorale;
		o.checkMorale = function (_change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false)
		{
			if(change < 0 && this.m.Skills.hasSkill("racial.satyr") && (this.m.MoraleState == this.Const.MoraleState.Breaking || _type == this.Const.MoraleCheckType.Fatality));
			{
				return false;
			}
			return checkMorale(_change, _difficulty, _type,_showIconBeforeMoraleIcon,_noNewLine);
		}
	});
	
	local AxeSkills = [
		"chop",
		"round_swing",
		"split_axe",
		"split_man",
		"strike_skill"
	];
	
	foreach (skill in AxeSkills)
	{
		::mods_hookClass("skills/actives/" + skill, function (o)
		{
			local isOneHandAxe = function()
			{
				local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
				local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
				return main != null && off == null;
			};
			
			local onAfterUpdate = o.onAfterUpdate;
			o.onAfterUpdate = function( _properties )
			{
				if (this.m.ID == "actives.strike")
				{
					return;	
				}
				
				onAfterUpdate(_properties);

				if (this.m.Container.hasSkill("perk.satyer_mastery_axe"))
				{
					this.m.FatigueCostMult = 0.5;
					_properties.MeleeSkill += isOneHandAxe() ? 10 : 5;
				}
			}
		});
	}
}
