this.satyr_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},

	function create()
	{
		this.character_background.create();
		this.m.ID = "background.dryad";
		this.m.Name = "Dryad";
		this.m.Icon = "ui/backgrounds/background_39.png";
		this.m.HiringCost = 2500;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.asthmatic",
			"trait.brute",
			"trait.clubfooted",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fearless",
			"trait.fragile",
			"trait.gluttonous",
			"trait.greedy",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hesitant",
			"trait.insecure",
			"trait.night_owl",
			"trait.pessimist",
			"trait.quick",
			"trait.short_sighted",
			"trait.spartan",
			"trait.strong",
			"trait.superstitious",
			"trait.sure_footing",
			"trait.tiny",
			"trait.tough"
		];
		this.m.Names = [
		];
		this.m.Titles = [
		];

		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		
		//the appearance is placeholder
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
	}

	function getTooltip()
	{
		return [
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
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "WIP"
			}
		];
	}

	function onBuildDescription()
	{
		return "{WIP}";
	}

		function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				15
			],
			Bravery = [
				10,
				15
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				3,
				3
			],
			RangedSkill = [
				-7,
				-7
			],
			MeleeDefense = [
				5,
				10
			],
			RangedDefense = [
				0,
				5
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		this.m.Container.ActionPoints--;
		this.m.Container.add(this.new("scripts/skills/racial/satyr_racial"));
		this.m.Container.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Container.add(this.new("scripts/skills/perks/perk_pathfinder"));
	}
});