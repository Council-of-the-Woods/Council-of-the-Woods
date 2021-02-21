this.talent_customizer <- {
	m = {
		ExcludedTalents = []

		PrimaryTalents = []
		PrimaryTalentChances = [60,30] //1star, 2star (chance in % [100 - (1star + 2star) = 3star chance])
		NumOfPrimary = [0,0] //lower bound, upper bound for number of talents in this category

		SecondaryTalents = []
		SecondaryTalentChances = [60,30]
		NumOfSecondary = [0,0]

		NumOfOther = [0,0]
		OtherTalentChances = [60,30]
	}

	function fillTalents(possibleTalents, talentChances, numOfTalents, player) //For primary and secondary talents
	{
		local rolledNumTalents = this.Math.rand(numOfTalents[0], numOfTalents[1]);
		local talentOptions = possibleTalents;

		for( local i = 0; i < rolledNumTalents; i++)
		{
			local rolledTalentIndex = this.Math.rand(0, talentOptions.len());
			local i = talentOptions[rolledTalentIndex];
			talentOptions.remove(rolledTalentIndex);

			local r = this.Math.rand(1, 100);

			if (r <= talentChances[0])
			{
				player.m.Talents[i] = 1;
			}
			else if (r <= talentChances[0] + talentChances[1])
			{
				player.m.Talents[i] = 2;
			}
			else
			{
				player.m.Talents[i] = 3;
			}
		}
	}

	function fillRemainingTalents(talentChances, numOfTalents, player) //For remaining talents
	{
		local rolledNumTalents = this.Math.rand(numOfTalents[0], numOfTalents[1]);

		for( local done = 0; done < rolledNumTalents; )
		{
			local i = this.Math.rand(0, this.Const.Attributes.COUNT - 1);

			if (player.m.Talents[i] == 0 && this.ExcludedTalents.find(i) == null)
			{
				local r = this.Math.rand(1, 100);

				if (r <= talentChances[0])
				{
					player.m.Talents[i] = 1;
				}
				else if (r <= talentChances[0] + talentChances[1])
				{
					player.m.Talents[i] = 2;
				}
				else
				{
					player.m.Talents[i] = 3;
				}

				done = ++done;
			}
		}
	}

	function fillCustomTalentValues(player)
	{
		player.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		if (player.getBackground() != null && player.getBackground().isUntalented())
		{
			return;
		}

		fillTalents(this.m.PrimaryTalents, this.m.PrimaryTalentChances, this.m.NumOfPrimary, player);
		fillTalents(this.m.SecondaryTalents, this.m.SecondaryTalentChances, this.m.NumOfSecondary, player);
		fillRemainingTalents(this.m.OtherTalentChances, this.m.OtherTalentChances, player)
	} 
}