this.satyr_charge_skill <- this.inherit("scripts/skills/skill", {
	m = {
		FailToKnockBack = false,
		IsUpgrade = false
	},
	function create()
	{
		this.m.ID = "actives.satyr_charge";
		this.m.Name = "Satyric Charge";
		this.m.Description = "";
		this.m.Icon = "skills/active_10.png";
		this.m.IconDisabled = "skills/active_10_sw.png";
		this.m.Overlay = "active_10";
		this.m.SoundOnUse = [
			"sounds/combat/knockback_01.wav",
			"sounds/combat/knockback_02.wav",
			"sounds/combat/knockback_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingActorPitch = true;
		this.m.IsSpearwallRelevant = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 1;
		this.m.ChanceDisembowel = 45;
		this.m.ChanceSmash = 10;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Charges at the target"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can cause [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] and [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color]"
			}
		]);
		
		if (this.m.IsUpgrade)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "ignoring Zone of Control and Spear Wall"
			});
			
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Always hits"
			});
		}

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
			});
		}
		
		if (!this.isAffectedByZOC())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used while engaging melee[/color]"
			});
		}

		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		
		if (actor.getSkills().hasSkill("perk.something_to_upgrade_this_skill"))
		{
			this.m.IsSpearwallRelevant = false;
			this.m.IsUpgrade = true;
			this.m.IsUsingHitchance = false;
		}
	}
	
	function isAffectedByZOC()
	{
		if (this.m.IsUpgrade)
		{
			return true;
		}
		else
		{
			return !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
		}
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && this.isAffectedByZOC() && !this.getContainer().getActor().getCurrentProperties().IsRooted;;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local hasTile = this.getDestinationTile( _originTile, _targetTile , true);

		return hasTile;
	}
	
	function onUse( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local destTile;
		local destTile = this.getDestinationTile(myTile, _targetTile);
		
		if (destTile == null)
		{
			return false;
		}
		
		this.m.FailToKnockBack = false;
		this.getContainer().setBusy(true);
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled
		};
		
		if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			local myPos = _user.getPos();
			local targetPos = _targetTile.Pos;
			local distance = tag.OldTile.getDistanceTo(_targetTile);
			local Dx = (targetPos.X - myPos.X) / distance;
			local Dy = (targetPos.Y - myPos.Y) / distance;

			for( local i = 0; i < distance; i = ++i )
			{
				local x = myPos.X + Dx * i;
				local y = myPos.Y + Dy * i;
				local tile = this.Tactical.worldToTile(this.createVec(x, y));

				if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
					}
				}
			}
		}
		
		this.Tactical.getNavigator().teleport(_user, destTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		return true;
	}
	
	function onRepelled( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}
	
	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			this.m.DirectDamageMult = 0.25;
		
			_properties.DamageRegularMin = actor.getHitpoints() * 0.1;
			_properties.DamageRegularMax = actor.getHitpoints() * 0.2;
			_properties.DamageArmorMult *= 0.85;
			_properties.FatigueDealtPerHitMult += 2.0;
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
			
			if (_targetEntity == null)
			{
				return;
			}
			
			if (this.m.FailToKnockBack)
			{
				_properties.DamageRegularMin = actor.getHitpoints() * 0.2;
				_properties.DamageRegularMax = actor.getHitpoints() * 0.2;
			}
			else
			{
				this.m.DirectDamageMult = 0.1;
				_properties.DamageRegularMin = actor.getHitpoints() * 0.1;
				_properties.DamageRegularMax = actor.getHitpoints() * 0.1;
			}
		}
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local dirToTarget = _tag.OldTile.getDirectionTo(myTile);
		local _target = _tag.TargetTile.getEntity();

		if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " charges");
		}
		
		local ZOC = [];
		this.getContainer().setBusy(false);
		
		if (_tag.Skill.m.IsSpearwallRelevant)
		{
			for( local i = 0; i != 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = myTile.getNextTile(i);

					if (!tile.IsOccupiedByActor)
					{
					}
					else
					{
						local actor = tile.getEntity();

						if (actor.isAlliedWith(_entity) || actor.getCurrentProperties().IsStunned)
						{
						}
						else
						{
							ZOC.push(actor);
						}
					}
				}
			}

			foreach( actor in ZOC )
			{
				if (!actor.onMovementInZoneOfControl(_entity, true))
				{
					continue;
				}

				if (actor.onAttackOfOpportunity(_entity, true))
				{
					if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " lunges and is repelled");
					}

					if (!_entity.isAlive() || _entity.isDying())
					{
						return;
					}

					local dir = myTile.getDirectionTo(_tag.OldTile);

					if (myTile.hasNextTile(dir))
					{
						local tile = myTile.getNextTile(dir);

						if (tile.IsEmpty && this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.getDistanceTo(actor.getTile()) > 1)
						{
							_tag.TargetTile = tile;
							this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
							return;
						}
					}
				}
			}
		}
		
		if (this.findTileToKnockBackTo(_entity.getTile(), _target.getTile()) == null)
		{
			_tag.Skill.m.FailToKnockBack = true;
		}
		
		local ImpactDamage = this.Math.maxf(1, _target.getHitpoints() * 0.05);
		local success = _tag.Skill.attackEntity(_entity, _target);
		local forwardTile;
		
		if (hasNexTile)
		{
			forwardTile = _target.getTile().getNextTile(dir);
		}
		
		if (success)
		{
			if (hasNexTile)
			{
				if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && this.Math.abs(forwardTile.Level - _target.getTile().Level) <= 1)
				{
					if (this.Math.rand(1, 100) <= 5 && !forwardTile.getEntity().getCurrentProperties().IsImmuneToStun)
					{
						forwardTile.getEntity().getSkills().add(this.new("scripts/skills/effects/stunned_effect"));

						if (!_entity.isHiddenToPlayer() && forwardTile.IsVisibleForPlayer)
						{
							this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " has stunned " + this.Const.UI.getColorizedEntityName(forwardTile.getEntity()) + " for one turn");
						}
					}
					
					local HitInfo = clone this.Const.Tactical.HitInfo;
					HitInfo.DamageRegular = ImpactDamage;
					HitInfo.DamageArmor = ImpactDamage;
					HitInfo.DamageDirect = 0.1;
					HitInfo.BodyPart = this.Const.BodyPart.Body;
					HitInfo.BodyDamageMult = 1.0;
					forwardTile.getEntity().onDamageReceived(_entity, _tag.Skill, HitInfo);
				}
			}
			
			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _target.getPos());
			}	
			
			if (_target.isAlive() && !_target.isDying())
			{	
				_tag.Skill.applyEffectToTarget(_entity, _target, _target.getTile());
			}
			
			local HitInfo = clone this.Const.Tactical.HitInfo;
			HitInfo.DamageRegular = 10;
			HitInfo.DamageDirect = 1.0;
			HitInfo.BodyPart = this.Const.BodyPart.Head;
			HitInfo.BodyDamageMult = 1.0;
			_entity.onDamageReceived(null, null, HitInfo);
		}
	}
	
	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}
		
		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null)
		{	
			if (this.Math.rand(1, 100) > 10 && !_target.getCurrentProperties().IsImmuneToStun)
			{
				return;
			}
			
			_target.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has stunned " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 5 && !_target.getCurrentProperties().IsImmuneToStun)
			{
				_target.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has stunned " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
				}
			}	
			
			if (!_target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !_target.getCurrentProperties().IsRooted)
			{
				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
				}

				local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

				if (knockToTile == null)
				{
					return;
				}

				if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_target));
				}

				local skills = _target.getSkills();
				skills.removeByID("effects.shieldwall");
				skills.removeByID("effects.spearwall");
				skills.removeByID("effects.riposte");
				_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
				local differentLevel = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1);
				local damage = 0;
				
				if (differentLevel == 1)
				{
					damage = _target.getHitpoints() * 0.1 + _target.getArmor(this.Const.BodyPart.Body) * 0.05;
				}
				else if (differentLevel > 1)
				{
					damage = _target.getHitpoints() * 0.15 + _target.getArmor(this.Const.BodyPart.Body) * 0.05;
				}
				
				if (damage == 0)
				{
					this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
				}
				else
				{
					local p = this.getContainer().getActor().getCurrentProperties();
					local tag = {
						Attacker = _user,
						Skill = this,
						HitInfo = clone this.Const.Tactical.HitInfo
					};
					tag.HitInfo.DamageRegular = damage;
					tag.HitInfo.DamageDirect = 1.0;
					tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
					tag.HitInfo.BodyDamageMult = 1.0;
					tag.HitInfo.FatalityChanceMult = 1.0;
					this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
				}
			}
		}
	}
	
	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		return null;
	}
	
	function getDestinationTile( _myTile, _targetTile , _IsReturnBool = false)
	{
		local ret;
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsEmpty && tile.getDistanceTo(_myTile) >= (this.m.MinRange - 1) && tile.getDistanceTo(_myTile) <= (this.m.MaxRange - 1) && this.Math.abs(_myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
				{
					ret = tile;
					break;
				}
			}
		}
		
		if (!_IsReturnBool)
		{
			return ret;
		}
		
		return ret != null;
	}

});

