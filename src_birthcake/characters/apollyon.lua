local Mod = BirthcakeRebaked
local game = Mod.Game

local APOLLYON_CAKE = {}
BirthcakeRebaked.Birthcake.APOLLYON = APOLLYON_CAKE

APOLLYON_CAKE.DOUBLE_VOID_CHANCE = 0.25
--APOLLYON_CAKE.BIRTHRIGHT_SPAWN_CHANCE = 0.05

---@param player EntityPlayer
function APOLLYON_CAKE:OnPlayerInit(player)
	if player:GetPlayerType() == PlayerType.PLAYER_APOLLYON then
		local player_run_save = Mod:RunSave(player)
		player_run_save.ApollyonCakeHasVoid = player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, APOLLYON_CAKE.OnPlayerInit)

---@param player EntityPlayer
function APOLLYON_CAKE:OnVoidUse(_, _, player, _, _, _)
	local playHorn = false
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON) then
		local player_run_save = Mod:RunSave(player)
		local trinketList = {}
		local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
		local trinketMult = Mod:GetTrinketMult(player, true)

		--[[ if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			and player_run_save.ApollyonCakeTrinketList
			and #player_run_save.ApollyonCakeTrinketList > 0
			and rng:RandomFloat() <= APOLLYON_CAKE.BIRTHRIGHT_SPAWN_CHANCE * trinketMult
		then
			local trinketID = player_run_save.ApollyonCakeTrinketList[rng:RandomInt(#player_run_save.ApollyonCakeTrinketList) + 1]
			local trinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketID,
			Mod.Game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true, false), Vector.Zero, nil)
			Mod:GetData(trinket).ApollyonCakeTempIgnoreVoid = true
		end ]]
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
			local pickup = ent:ToPickup()
			---@cast pickup EntityPickup
			local data = Mod:GetData(pickup)
			if data.ApollyonCakeTempIgnoreVoid then
				data.ApollyonCakeTempIgnoreVoid = nil
			else
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
				poof.SpriteScale = Vector(0.5, 0.5)
				poof.Color = Color(0.6, 0.35, 0.6)
				pickup.Timeout = 4

				player_run_save.ApollyonCakeTrinketList = player_run_save.ApollyonCakeTrinketList or {}
				table.insert(trinketList, { TrinketType = pickup.SubType, FirstTime = pickup.Touched })
				table.insert(player_run_save.ApollyonCakeTrinketList, pickup.SubType)

				if trinketMult > 1
					and rng:RandomFloat()
					<= Mod:GetBalanceApprovedChance(APOLLYON_CAKE.DOUBLE_VOID_CHANCE, trinketMult - 1)
				then
					table.insert(trinketList, { TrinketType = pickup.SubType, FirstTime = pickup.Touched })
					table.insert(player_run_save.ApollyonCakeTrinketList, pickup.SubType)
					playHorn = true
				end
				Isaac.RunCallbackWithParam(Mod.ModCallbacks.APOLLYON_VOID_TRINKET, pickup.SubType, pickup)
			end
		end
		if #trinketList > 0 then
			Mod:AddSmeltedTrinkets(player, trinketList)
			if playHorn then
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
			end
		end
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, APOLLYON_CAKE.OnVoidUse, CollectibleType.COLLECTIBLE_VOID)

---Even if you LOSE Birthcake or are no longer Apollyon, the items are tied to Void, so you should keep the voided trinkets, just can't void any further ones
---@param player EntityPlayer
function APOLLYON_CAKE:ManageVoidedTrinkets(player)
	local player_run_save = Mod:RunSave(player)
	if player_run_save.ApollyonCakeHasVoid and not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
		player_run_save.ApollyonCakeHasVoid = false
		local trinketList = player_run_save.ApollyonCakeTrinketList
		if trinketList then
			Mod:RemoveSmeltedTrinkets(player, trinketList)
		end
	--It's nil if you've never been Apollyon with Void
	elseif player_run_save.ApollyonCakeHasVoid == false
		and player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
		and not player.QueuedItem.Item
	then
		player_run_save.ApollyonCakeHasVoid = true
		local trinketList = player_run_save.ApollyonCakeTrinketList
		if trinketList then
			Mod:AddSmeltedTrinkets(player, trinketList)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, APOLLYON_CAKE.ManageVoidedTrinkets)

---@param player EntityPlayer
function APOLLYON_CAKE:CheckApollyonChange(player)
	APOLLYON_CAKE:OnPlayerInit(player)
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, APOLLYON_CAKE.CheckApollyonChange)

-- Apollyon B Birthcake

---@param player EntityPlayer
function APOLLYON_CAKE:TaintedTrinketConsumer(_, _, player, _, _, _)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON_B) then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
			local pickup = ent:ToPickup()
			---@cast pickup EntityPickup

			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
			poof.SpriteScale = Vector(0.5, 0.5)
			poof.Color = Color(1, 0, 0)
			pickup.Timeout = 4
			local trinketMult = Mod:GetTrinketMult(player)
			local subType = (trinketMult > 1 or pickup.SubType > TrinketType.TRINKET_GOLDEN_FLAG) and
			CollectibleType.COLLECTIBLE_BREAKFAST or CollectibleType.COLLECTIBLE_HALO_OF_FLIES
			local familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, subType,
				pickup.Position, Vector.Zero, player)
			familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			Isaac.RunCallbackWithParam(Mod.ModCallbacks.APOLLYON_B_ABYSS_TRINKET, pickup.SubType, pickup)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, APOLLYON_CAKE.TaintedTrinketConsumer, CollectibleType.COLLECTIBLE_ABYSS)
