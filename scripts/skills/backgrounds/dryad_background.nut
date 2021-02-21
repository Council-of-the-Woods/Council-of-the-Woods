this.dryad_background <- this.inherit("scripts/skills/backgrounds/character_background", {
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
			"trait.swift",
			"trait.tiny",
			"trait.tough"
		];
		this.m.Names = [
			"Itorn",
			"Unzaquam",
			"Jutaz",
			"Ulaqiohr",
			"Otarum",
			"Oraxium",
			"Uqiohr",
			"Anotorn",
			"Qenorim",
			"Ildor",
			"Aqiohr",
			"Olezin",
			"Udalf",
			"Everhan",
			"Elogrus",
			"Ekey",
			"Urubahn",
			"Grumarim",
			"Unumonar",
			"Osior",
			"Virnas",
			"Ebus",
			"Ulvidus",
			"Agroqor",
			"Kabeus",
			"Griwix",
			"Irumaex",
			"Ikius",
			"Ulzidalf",
			"Olrageor",
			"Gandalf"
		];
		this.m.Titles = [
			"The Nature Caller",
			"The Forest Keeper",
			"The Earthen Guardian"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints
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

	function buildAttributes()
	{
		this.character_background.buildAttributes();
		local b = this.getContainer().getActor().getBaseProperties();
		
		//set starting base health to 80
		b.Hitpoints = 80; 
		
		//add additional ranged skill, defense to base stat
		b.RangedSkill += 5;
		b.RangedDefense += 10;
		
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		
		//make movement cost 1 less AP
		this.getContainer().getActor().m.ActionPointCosts = this.Const.PathfinderMovementAPCost;
		
		
		//add unique racial traits
		this.getContainer.getActor.getSkills().add("scripts/skills/racial/pristine_being_racial");
		this.getContainer.getActor.getSkills().add("scripts/skills/racial/pure_spiritual_structure_racial");
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		
		//starting equiqment is currently a placeholder too
		items.equip(this.new("scripts/items/armor/wizard_robe"));
		items.equip(this.new("scripts/items/helmets/wizard_hat"));
	}

});

