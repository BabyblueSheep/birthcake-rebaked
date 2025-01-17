local Mod = BirthcakeRebaked
local loader = BirthcakeRebaked.PatchesLoader

local function accurateBlurbsPatch()
	local DESCRIPTION_SHARE = {
		[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
		[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
		[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
		[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
	}

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	local BIRTHCAKE_DESCRIPTION = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Dice Shards in Treasure and Boss room",
			ru = "Осколки кости в Сокровищнице и комнате Босса",
			pl = "Odłamki Kości w pokojach Skarbów i Bossa",
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Heart pickups may double. Yum Heart gives a half soul heart",
			ru = "Подбираемые сердца могут удвоиться. Ням Сердце! дает половину сердца души",
			pl = "Serca są czasami podwojone. Serduszko daje pół serca dusz",
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Slot and Fortune Machines may refund money. Crane Game too, but lower chance",
			ru = "Игральные автоматы могут возвратить деньги. Меньший шанс для Кран-машины",
			pl = "Automaty do Gier i z Wróżbami czasami zwracają pieniądze. Chwytaki również, ale rzadziej",
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Flat and multiplier damage up. Prevents death but gets consumed",
			ru = "Плоский урон ↑, Множитель урона ↑. Спасает от смерти, после чего исчезает",
			pl = "Większe obrażenia i mnożnik obrażeń. Zapobiega śmierci, ale zostaje zniszcony",
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Active items create poops based on charge",
			ru = "Активные предметы создают какашки в зависимости от их заряда",
			pl = "Przedmioty aktywne tworzą kupy zależnie od ładunków",
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "Red hearts are hurt before others, no devil deal penalty",
			ru = "Красные сердца в приоритете при получении урона, при этом шанс сделок не снижается",
			pl = "Obrażenia najpierw zabierają czerwone zdrowie, bez zmniejszania szansy na pokój Diabła",
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Drops red hearts at maximum rage",
			ru = "Роняет красные сердца при максимальном уровне ярости",
			pl = "Tworzy serduszka po osiągnieciu maksymalnego gniewu",
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Longer brimstone from dealing damage",
			ru = "Длительность луча серы увеличивается по мере нанесения урона",
			pl = "Zadawanie obrażeń wydłuża laser",
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Room damage and soul heart on revival",
			ru = "Урон по комнате и сердце души при возрождении",
			pl = "Obrażenia w pokoju i serce dusz po odrodzeniu",
		},
		[PlayerType.PLAYER_LAZARUS2] = {
			en_us = "Wait till next floor for effect",
			ru = "Подожди следующего этажа для эффекта",
			pl = "Poczekaj do następnego piętra",
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "3 random gulped trinkets",
			ru = "Приваривает 3 случайных брелока",
			pl = "3 losowe połknięte trynkiety",
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Two free active uses per floor. Eternal D6 does a D6 + Birthright reroll",
			ru = "2 бесплатных использования Вечного Д6 каждый этаж. Вечный Д6 делает реролл Д6 и Права первородства",
			pl = "2 darmowe użycia przedmiotu na piętro. Wieczne D6 wykonuje efekt D6 + Prawo Urodzenia",
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Familiars have a chance to copy your tear effects",
			ru = "Спутники имеют шанс скопировать эффекты слез",
			pl = "Sojusznicy czasami kopiują efekty twoich łez",
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Nickel in Shop and Devil rooms",
			ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
			pl = "Piątak w sklepach i pokojach Diabła",
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Voidable trinkets",
			ru = "Поглощаемые брелки",
			pl = "Jadalne trynkiety",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Shoot Forgotten's Body to charge it, swap back for tears up",
			ru = 'Стрельба по телу Забытого "заряжает" его. При изменении режима повышение скорострельности',
			pl = "Strzel w ciało, aby je naładować. Wróc do niego, aby dostać bonus do szybkostrzelności"
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Additional Wisp may spawn on active use",
			ru = "При использовании активируемого предмета может появиться дополнительный огонек",
			pl = "Użyte przedmioty czasami dają dodatkowe ogniki",
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Gain a small percentage of stats from the other brother",
			ru = "Получение небольшого процента характеристик другого брата",
			pl = "Dostań część statystyk od brata",
		},
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Extra inventory slot",
			ru = "Дополнительный слот инвентаря",
			pl = "Dodatkowe miejsce w ekwipunku",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Temporary hearts from enemies explode",
			ru = "Временные сердца, падающие с врагов, взрываются",
			pl = "Serduszka z przeciwników wybuchają",
		},
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Double pickups are split into their halves",
			ru = "Двойные подбираемые предметы распадаются на два обычных",
			pl = "Rozdziela podwójne pickupy",
		},
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = "Passing through enemies with Dark Arts gives active charge",
			ru = "???",
			pl = "Mroczne Techniki ładują się szybciej, gdy trafiają przeciwników",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Poops block projectiles and slow enemies",
			ru = "Какашки блокируют снаряды и замедляют врагов",
			pl = "Kupy blokują pociski i spowalniają przeciwników",
		},
		[PlayerType.PLAYER_EVE_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Clearing rooms may extend Berserk and spawn a heart",
			ru = "Зачистка комнат может продлить действие Берсерка и создать сердце",
			pl = "Kończenie pokojów czasami wydłuża stan Berserka i tworzy serduszko",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = "Sneeze brimstone-marking tears. Small chance to stick",
			ru = "Вычихивание слез с меткой серы, имеющих маленький шанс прилипнуть",
			pl = "Kichaj naznaczającymi łzami. Czasami są lepkie",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = "3 random gulped trinkets, but they reroll",
			ru = "???",
			pl = "3 losowe połknięte trynkiety, ciągle zmienne",
		},
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Spawns a mini shop every floor",
			ru = "Создает мини-магазин каждый этаж",
			pl = "Mini sklep na każdym piętrze",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Abyssable trinkets for half damage locusts",
			ru = "Поглощение брелоков создает саранчу с половиной урона персонажа",
			pl = "Pochłaniaj trynkiety, aby dostać szarańcze o połowicznych obrażeniach",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Killing enemies spawns orbitals. Throw Forgotten to fire them",
			ru = "Создает орбитальные кости при убийстве врагов. Бросок Забытого стреляет ими",
			pl = "Zabijanie przeciwników tworzy kości. Rzuć ciałem, by je wystrzelić",
		},
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Double health wisps",
			ru = "Двойное здоровье у огоньков",
			pl = "Ogniki mają podwojone zdrowie",
		},
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = "???",
			ru = "???",
		}
	}

	for sharedDescription, copyDescription in pairs(DESCRIPTION_SHARE) do
		BIRTHCAKE_DESCRIPTION[sharedDescription] = BIRTHCAKE_DESCRIPTION[copyDescription]
	end

	Mod:AddCallback(Mod.ModCallbacks.GET_BIRTHCAKE_ITEMTEXT_DESCRIPTION, function(_, player)
		local playerType = player:GetPlayerType()
		if BIRTHCAKE_DESCRIPTION[playerType] and Mod:TryGetTranslation(BIRTHCAKE_DESCRIPTION[playerType]) then
			return Mod:TryGetTranslation(BIRTHCAKE_DESCRIPTION[playerType])
		end
	end)
end

loader:RegisterPatch("AccurateBlurbs", accurateBlurbsPatch)
