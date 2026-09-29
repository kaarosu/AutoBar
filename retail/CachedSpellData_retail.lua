local _, AB = ...

local types = AB.types	---@class ABTypes
local code = AB.code	---@class ABCode

local ABGData = AutoBarGlobalDataObject

-- NOTE: This entire set of code runs in ~2ms, so no need to try to optimize it
local cache_timer_start = debugprofilestop();
--All
code.cache_spell_data(125439, "Revive Battle Pets");
code.cache_spell_data(83958, "Mobile Banking");
code.cache_spell_data(460905, "Warbands");
code.cache_spell_data(460905, "Warband Bank Distance Inhibitor");
code.cache_spell_data(431280, "The Warband Map to Everywhere All At Once");
code.cache_spell_data(431280, "Warband Map to Everywhere All At Once");
code.cache_spell_data(448834, "Skyriding Flight Style");
code.cache_spell_data(436854, "Switch Flight Style");
code.cache_spell_data(445424, "Hero's Path: War Within Raids");
code.cache_spell_data(251463, "Vindicaar Matrix Crystal");
code.cache_spell_data(294954, "Anomaly Detection Mark I");
code.cache_spell_data(299064, "Mechanism Bypass");

--#region Racial
code.cache_spell_data(291944, "Regeneratin'");
code.cache_spell_data(281954, "Pterrordax Swoop");
code.cache_spell_data(292752, "Embrace of the Loa");
code.cache_spell_data(292748, "Embrace of Pa'ku");
code.cache_spell_data(292740, "Embrace of Akunda");
code.cache_spell_data(292742, "Embrace of Bwonsamdi");
code.cache_spell_data(292743, "Embrace of Gonk");
code.cache_spell_data(292744, "Embrace of Kimbul");
code.cache_spell_data(292745, "Embrace of Krag'wa");
code.cache_spell_data(26297, "Berserking");
code.cache_spell_data(20572, "Blood Fury");
code.cache_spell_data(274738, "Ancestral Call");
code.cache_spell_data(7744, "Will of the Forsaken");
code.cache_spell_data(20577, "Cannibalize");
code.cache_spell_data(20549, "War Stomp");
code.cache_spell_data(255654, "Bull Rush");
code.cache_spell_data(25046, "Arcane Torrent");
code.cache_spell_data(202719, "Arcane Torrent");
code.cache_spell_data(69070, "Rocket Jump");
code.cache_spell_data(69041, "Rocket Barrage");
code.cache_spell_data(69046, "Pack Hobgoblin");
code.cache_spell_data(260364, "Arcane Pulse");
code.cache_spell_data(255661, "Cantrips");
code.cache_spell_data(312411, "Bag of Tricks");
code.cache_spell_data(312455, "Rummage Your Bag");
code.cache_spell_data(312192, "Make Camp");
code.cache_spell_data(312193, "Return to Camp");
code.cache_spell_data(59752, "Will to Survive");
code.cache_spell_data(20594, "Stoneform");
code.cache_spell_data(265221, "Fireblood");
code.cache_spell_data(265225, "Mole Machine");
code.cache_spell_data(58984, "Shadowmeld");
code.cache_spell_data(20589, "Escape Artist");
code.cache_spell_data(312924, "Hyper Organic Light Originator");
code.cache_spell_data(28880, "Gift of the Naaru");
code.cache_spell_data(59542, "Gift of the Naaru");
code.cache_spell_data(255647, "Light's Judgment");
code.cache_spell_data(259930, "Forge of Light");
code.cache_spell_data(68992, "Darkflight");
code.cache_spell_data(68996, "Two Forms");
code.cache_spell_data(87840, "Running Wild");
code.cache_spell_data(256948, "Spatial Rift");
code.cache_spell_data(287712, "Haymaker");
code.cache_spell_data(107079, "Quaking Palm");
code.cache_spell_data(368970, "Tail Swipe");
code.cache_spell_data(357214, "Wing Buffet");
code.cache_spell_data(369536, "Soar");
code.cache_spell_data(368847, "Visage");
code.cache_spell_data(451903, "Azerite Surge");
code.cache_spell_data(433544, "Ingest Minerals");
code.cache_spell_data(1259416, "Walk on Air");
code.cache_spell_data(1259705, "Read Ley Line");
code.cache_spell_data(1259686, "Skysight");
--#endregion

--#region Shaman Totems & Abilities
code.cache_spell_data(8071, "Stoneskin Totem");
code.cache_spell_data(2484, "Earthbind Totem");
code.cache_spell_data(5730, "Stoneclaw Totem");
code.cache_spell_data(8075, "Strength of Earth Totem");
code.cache_spell_data(8143, "Tremor Totem");
code.cache_spell_data(3599, "Searing Totem");
code.cache_spell_data(1535, "Fire Nova Totem");
code.cache_spell_data(16387, "Flametongue Totem");
code.cache_spell_data(8190, "Magma Totem");
code.cache_spell_data(8181, "Frost Resistance Totem");
code.cache_spell_data(5394, "Healing Stream Totem");
code.cache_spell_data(5675, "Mana Spring Totem");
code.cache_spell_data(16190, "Mana Tide Totem");
code.cache_spell_data(8166, "Poison Cleansing Totem");
code.cache_spell_data(8170, "Disease Cleansing Totem");
code.cache_spell_data(10538, "Fire Resistance Totem");
code.cache_spell_data(8512, "Windfury Totem");
code.cache_spell_data(8177, "Grounding Totem");
code.cache_spell_data(8835, "Grace of Air Totem");
code.cache_spell_data(10595, "Nature Resistance Totem");
code.cache_spell_data(6495, "Sentry Totem");
code.cache_spell_data(25908, "Tranquil Air Totem");
code.cache_spell_data(15107, "Windwall Totem");
code.cache_spell_data(8017, "Rockbiter Weapon");
code.cache_spell_data(8024, "Flametongue Weapon");
code.cache_spell_data(8033, "Frostbrand Weapon");
code.cache_spell_data(8232, "Windfury Weapon");
code.cache_spell_data(2645, "Ghost Wolf");
code.cache_spell_data(324, "Lightning Shield");
code.cache_spell_data(52127, "Water Shield");
code.cache_spell_data(974, "Earth Shield");
code.cache_spell_data(8042, "Earth Shock");
code.cache_spell_data(8056, "Frost Shock");
code.cache_spell_data(8058, "Flame Shock");
code.cache_spell_data(57994, "Wind Shear");
code.cache_spell_data(20608, "Reincarnation");
code.cache_spell_data(546, "Water Walking");
code.cache_spell_data(131, "Water Breathing");
code.cache_spell_data(556, "Astral Recall");
--#endregion
code.cache_spell_data(131204, "Path of the Jade Serpent");
code.cache_spell_data(131205, "Path of the Stout Brew");
code.cache_spell_data(131206, "Path of the Shado-Pan");
code.cache_spell_data(131222, "Path of the Mogu King");
code.cache_spell_data(131225, "Path of the Setting Sun");
code.cache_spell_data(131231, "Path of the Scarlet Blade");
code.cache_spell_data(131229, "Path of the Scarlet Mitre");
code.cache_spell_data(131232, "Path of the Necromancer");
code.cache_spell_data(131228, "Path of the Black Ox");

--#region Keystone Hero Dungeon Portals
-- The War Within
code.cache_spell_data(445417, "Teleport: The Stonevault");
code.cache_spell_data(445414, "Teleport: The Dawnbreaker");
code.cache_spell_data(445444, "Teleport: Ara-Kara, City of Echoes");
code.cache_spell_data(445443, "Teleport: City of Threads");
code.cache_spell_data(445418, "Teleport: The Rookery");
code.cache_spell_data(445440, "Teleport: Cinderbrew Meadery");
code.cache_spell_data(445441, "Teleport: Darkflame Cleft");
code.cache_spell_data(445416, "Teleport: Priory of the Sacred Flame");
code.cache_spell_data(464068, "Teleport: Grim Batol");
code.cache_spell_data(464067, "Teleport: Siege of Boralus");
code.cache_spell_data(464070, "Teleport: Mists of Tirna Scithe");
code.cache_spell_data(464069, "Teleport: The Necrotic Wake");
code.cache_spell_data(1216786, "Teleport: Operation: Floodgate");

-- Dragonflight
code.cache_spell_data(393256, "Teleport: Ruby Life Pools");
code.cache_spell_data(393262, "Teleport: The Nokhud Offensive");
code.cache_spell_data(393267, "Teleport: The Azure Vault");
code.cache_spell_data(393273, "Teleport: Algeth'ar Academy");
code.cache_spell_data(393276, "Teleport: Neltharus");
code.cache_spell_data(393279, "Teleport: Brackenhide Hollow");
code.cache_spell_data(393283, "Teleport: Halls of Infusion");
code.cache_spell_data(393274, "Teleport: Uldaman: Legacy of Tyr");
code.cache_spell_data(424197, "Teleport: Dawn of the Infinite");

-- Shadowlands
code.cache_spell_data(354462, "Path of the Courageous");
code.cache_spell_data(354463, "Path of the Prowling Sinstone");
code.cache_spell_data(354464, "Path of the Plagued");
code.cache_spell_data(354465, "Path of the Misty Forest");
code.cache_spell_data(354466, "Path of the Sinful Soul");
code.cache_spell_data(354467, "Path of the Ascended");
code.cache_spell_data(354468, "Path of the Undefeated");
code.cache_spell_data(354469, "Path of the Scheming Broker");
code.cache_spell_data(367416, "Path of the Streetwise Merchant");
--#endregion


--#region DeathKnight
code.cache_spell_data(3714, "Path of Frost");
code.cache_spell_data(63560, "Dark Transformation");
code.cache_spell_data(45524, "Chains of Ice");
code.cache_spell_data(48707, "Anti-Magic Shell");
code.cache_spell_data(48792, "Icebound Fortitude");
code.cache_spell_data(47528, "Mind Freeze");
code.cache_spell_data(194679, "Rune Tap");
code.cache_spell_data(49028, "Dancing Rune Weapon");
code.cache_spell_data(46584, "Raise Dead");
code.cache_spell_data(49206, "Summon Gargoyle");
code.cache_spell_data(42650, "Army of the Dead");
code.cache_spell_data(55233, "Vampiric Blood");
code.cache_spell_data(48265, "Death's Advance");
code.cache_spell_data(212552, "Wraith Walk");
code.cache_spell_data(50977, "Death Gate");
--#endregion


--#region DemonHunter
code.cache_spell_data(195072, "Fel Rush");
code.cache_spell_data(198793, "Vengeful Retreat");
code.cache_spell_data(198589, "Blur");
code.cache_spell_data(196718, "Darkness");
code.cache_spell_data(204596, "Sigil of Flame");
code.cache_spell_data(207684, "Sigil of Misery");
code.cache_spell_data(202137, "Sigil of Silence");
code.cache_spell_data(183752, "Disrupt");
--#endregion


--#region Druid
code.cache_spell_data(22812, "Barkskin");
code.cache_spell_data(5487, "Bear Form");
code.cache_spell_data(768, "Cat Form");
code.cache_spell_data(193753, "Dreamwalk");
code.cache_spell_data(339, "Entangling Roots");
code.cache_spell_data(22842, "Frenzied Regeneration");
code.cache_spell_data(99, "Incapacitating Roar");
code.cache_spell_data(102342, "Ironbark");
code.cache_spell_data(5215, "Prowl");
code.cache_spell_data(1126, "Mark of the Wild");
code.cache_spell_data(197625, "Moonkin Form");
code.cache_spell_data(114282, "Treant Form");
code.cache_spell_data(106839, "Skull Bash");
code.cache_spell_data(210053, "Mount Form");
code.cache_spell_data(783, "Travel Form");
code.cache_spell_data(18960, "Teleport: Moonglade");
code.cache_spell_data(102401, "Wild Charge");
code.cache_spell_data(61336, "Survival Instincts");
--#endregion

--#region Evoker
code.cache_spell_data(364342, "Blessing of the Bronze");
code.cache_spell_data(351338, "Quell");
code.cache_spell_data(363916, "Obsidian Scales");
code.cache_spell_data(374348, "Renewing Blaze");
code.cache_spell_data(358267, "Hover");
code.cache_spell_data(355913, "Emerald Blossom");
code.cache_spell_data(360995, "Verdant Embrace");
--#endregion Evoker

--#region Hunter
code.cache_spell_data(61648, "Aspect of the Chameleon");
code.cache_spell_data(186257, "Aspect of the Cheetah");
code.cache_spell_data(186289, "Aspect of the Eagle");
code.cache_spell_data(186265, "Aspect of the Turtle");
code.cache_spell_data(193530, "Aspect of the Wild");
code.cache_spell_data(1462, "Beast Lore");
code.cache_spell_data(19574, "Bestial Wrath");
code.cache_spell_data(109248, "Binding Shot");
code.cache_spell_data(883, "Call Pet 1");
code.cache_spell_data(83242, "Call Pet 2");
code.cache_spell_data(83243, "Call Pet 3");
code.cache_spell_data(83244, "Call Pet 4");
code.cache_spell_data(83245, "Call Pet 5");
code.cache_spell_data(199483, "Camouflage");
code.cache_spell_data(5116, "Concussive Shot");
code.cache_spell_data(147362, "Counter Shot");
code.cache_spell_data(781, "Disengage");
code.cache_spell_data(2641, "Dismiss Pet");
code.cache_spell_data(6197, "Eagle Eye");
code.cache_spell_data(321297, "Eyes of the Beast");
code.cache_spell_data(6991, "Feed Pet");
code.cache_spell_data(5384, "Feign Death");
code.cache_spell_data(125050, "Fetch");
code.cache_spell_data(190925, "Harpoon");
code.cache_spell_data(109304, "Exhilaration");
code.cache_spell_data(7093, "Intimidation");
code.cache_spell_data(34026, "Kill Command");
code.cache_spell_data(53271, "Master's Call");
code.cache_spell_data(136, "Mend Pet");
code.cache_spell_data(187707, "Muzzle");
code.cache_spell_data(209997, "Play Dead");
code.cache_spell_data(982, "Revive Pet");
code.cache_spell_data(1250646, "Takedown");
code.cache_spell_data(1515, "Tame Beast");
code.cache_spell_data(210000, "Wake Up");
code.cache_spell_data(195645, "Wing Clip");
code.cache_spell_data(187650, "Freezing Trap");
code.cache_spell_data(187698, "Tar Trap");
code.cache_spell_data(162488, "Steel Trap");
--#endregion


--#region Mage
code.cache_spell_data(1459, "Arcane Intellect");
code.cache_spell_data(235313, "Blazing Barrier");
code.cache_spell_data(42955, "Conjure Refreshment");
code.cache_spell_data(759, "Conjure Mana Gem");
code.cache_spell_data(2139, "Counterspell");
code.cache_spell_data(110959, "Greater Invisibility");
code.cache_spell_data(11426, "Ice Barrier");
code.cache_spell_data(27619, "Ice Block");
code.cache_spell_data(66, "Invisibility");
code.cache_spell_data(235450, "Prismatic Barrier");
code.cache_spell_data(130, "Slow Fall");
code.cache_spell_data(31687, "Summon Water Elemental");
code.cache_spell_data(198111, "Temporal Shield");

code.cache_spell_data(33691, "Portal: Shattrath");
code.cache_spell_data(35715, "Teleport: Shattrath");
code.cache_spell_data(49361, "Portal: Stonard");
code.cache_spell_data(49358, "Teleport: Stonard");
code.cache_spell_data(49360, "Portal: Theramore");
code.cache_spell_data(49359, "Teleport: Theramore");
code.cache_spell_data(11418, "Portal: Undercity");
code.cache_spell_data(3563, "Teleport: Undercity");
code.cache_spell_data(11420, "Portal: Thunder Bluff");
code.cache_spell_data(3566, "Teleport: Thunder Bluff");
code.cache_spell_data(10059, "Portal: Stormwind");
code.cache_spell_data(3561, "Teleport: Stormwind");
code.cache_spell_data(32267, "Portal: Silvermoon");
code.cache_spell_data(32272, "Teleport: Silvermoon");
code.cache_spell_data(32266, "Portal: Exodar");
code.cache_spell_data(32271, "Teleport: Exodar");
code.cache_spell_data(11419, "Portal: Darnassus");
code.cache_spell_data(3565, "Teleport: Darnassus");
code.cache_spell_data(11416, "Portal: Ironforge");
code.cache_spell_data(3562, "Teleport: Ironforge");
code.cache_spell_data(11417, "Portal: Orgrimmar");
code.cache_spell_data(3567, "Teleport: Orgrimmar");
code.cache_spell_data(53142, "Portal: Dalaran");
code.cache_spell_data(53140, "Teleport: Dalaran");
code.cache_spell_data(224871, "Portal: Dalaran - Broken Isles");
code.cache_spell_data(224869, "Teleport: Dalaran - Broken Isles");

code.cache_spell_data(88344, "Teleport: Tol Barad - Horde");
code.cache_spell_data(88346, "Portal: Tol Barad - Horde");
code.cache_spell_data(88342, "Teleport: Tol Barad - Alliance");
code.cache_spell_data(88345, "Portal: Tol Barad - Alliance");

code.cache_spell_data(132621, "Teleport: Vale of Eternal Blossoms - Alliance");
code.cache_spell_data(132620, "Portal: Vale of Eternal Blossoms - Alliance");
code.cache_spell_data(132627, "Teleport: Vale of Eternal Blossoms - Horde");
code.cache_spell_data(132626, "Portal: Vale of Eternal Blossoms - Horde");

code.cache_spell_data(176248, "Teleport: Stormshield");
code.cache_spell_data(176246, "Portal: Stormshield");
code.cache_spell_data(176242, "Teleport: Warspear");
code.cache_spell_data(176244, "Portal: Warspear");
code.cache_spell_data(120145, "Teleport: Ancient Dalaran");
code.cache_spell_data(120146, "Portal: Ancient Dalaran");

code.cache_spell_data(193759, "Teleport: Hall of the Guardian");

code.cache_spell_data(281403, "Teleport: Boralus");
code.cache_spell_data(281400, "Portal: Boralus");
code.cache_spell_data(281404, "Teleport: Dazar'alor");
code.cache_spell_data(281402, "Portal: Dazar'alor");

code.cache_spell_data(344587, "Teleport: Oribos");
code.cache_spell_data(344597, "Portal: Oribos");

code.cache_spell_data(395277, "Teleport: Valdrakken");
code.cache_spell_data(395289, "Portal: Valdrakken");

code.cache_spell_data(446540, "Teleport: Dornogal");
code.cache_spell_data(446534, "Portal: Dornogal");

code.cache_spell_data(1259190, "Teleport: Silvermoon City");
code.cache_spell_data(1259194, "Portal: Silvermoon City");
--#endregion


--#region Monk
code.cache_spell_data(126892, "Zen Pilgrimage");
code.cache_spell_data(126895, "Zen Pilgrimage: Return");
code.cache_spell_data(115203, "Fortifying Brew");
code.cache_spell_data(116705, "Spear Hand Strike");
code.cache_spell_data(137639, "Storm, Earth, and Fire");
code.cache_spell_data(109132, "Roll");
code.cache_spell_data(115008, "Chi Torpedo");
code.cache_spell_data(101545, "Flying Serpent Kick");
code.cache_spell_data(116841, "Tiger's Lust");
code.cache_spell_data(122470, "Touch of Karma");
code.cache_spell_data(122783, "Diffuse Magic");
code.cache_spell_data(122278, "Dampen Harm");
code.cache_spell_data(116849, "Life Cocoon");
code.cache_spell_data(115450, "Detox");
code.cache_spell_data(115078, "Paralysis");
code.cache_spell_data(119381, "Leg Sweep");
code.cache_spell_data(116694, "Vivify");
code.cache_spell_data(322101, "Expel Harm");
code.cache_spell_data(123904, "Invoke Xuen, the White Tiger");
code.cache_spell_data(132578, "Invoke Niuzao, the Black Ox");
code.cache_spell_data(325197, "Invoke Chi-Ji, the Red Crane");
code.cache_spell_data(322118, "Invoke Yu'lon, the Jade Serpent");
--#endregion


--#region Paladin
code.cache_spell_data(31850, "Ardent Defender");
code.cache_spell_data(642, "Divine Shield");
code.cache_spell_data(1044, "Blessing of Freedom");
code.cache_spell_data(1022, "Blessing of Protection");
code.cache_spell_data(6940, "Blessing of Sacrifice");
code.cache_spell_data(204018, "Blessing of Spellwarding");
code.cache_spell_data(183218, "Hand of Hindrance");
code.cache_spell_data(96231, "Rebuke");
code.cache_spell_data(633, "Lay on Hands");
code.cache_spell_data(190784, "Divine Steed");
code.cache_spell_data(184662, "Shield of Vengeance");
code.cache_spell_data(317920, "Concentration Aura");
code.cache_spell_data(32223, "Crusader Aura");
code.cache_spell_data(465, "Devotion Aura");
code.cache_spell_data(183435, "Retribution Aura");
--#endregion


--#region Priest
code.cache_spell_data(17, "Power Word: Shield");
code.cache_spell_data(62618, "Power Word: Barrier");
code.cache_spell_data(34433, "Shadowfiend");
code.cache_spell_data(47585, "Dispersion");
code.cache_spell_data(47788, "Guardian Spirit");
code.cache_spell_data(33206, "Pain Suppression");
code.cache_spell_data(15487, "Silence");
code.cache_spell_data(1706, "Levitate");
code.cache_spell_data(21562, "Power Word: Fortitude");
code.cache_spell_data(19236, "Desperate Prayer");
code.cache_spell_data(121536, "Angelic Feather");
code.cache_spell_data(73325, "Leap of Faith");
code.cache_spell_data(123040, "Mindbender");
code.cache_spell_data(451235, "Voidwraith");
--#endregion


--#region Rogue
code.cache_spell_data(381664, "Amplifying Poison");
code.cache_spell_data(381637, "Atrophic Poison");
code.cache_spell_data(3408, "Crippling Poison");
code.cache_spell_data(2823, "Deadly Poison");
code.cache_spell_data(315584, "Instant Poison");
code.cache_spell_data(5761, "Numbing Poison");
code.cache_spell_data(8679, "Wound Poison");
code.cache_spell_data(5277, "Evasion");
code.cache_spell_data(1766, "Kick");
code.cache_spell_data(36554, "Shadowstep");
code.cache_spell_data(1784, "Stealth");
code.cache_spell_data(1856, "Vanish");
code.cache_spell_data(271877, "Blade Rush");
code.cache_spell_data(1804, "Pick Lock");
code.cache_spell_data(31224, "Cloak of Shadows");
code.cache_spell_data(185311, "Crimson Vial");
--#endregion


--#region Shaman
code.cache_spell_data(556, "Astral Recall");
code.cache_spell_data(198103, "Earth Elemental");
code.cache_spell_data(51533, "Feral Spirit");
code.cache_spell_data(198067, "Fire Elemental");
code.cache_spell_data(2645, "Ghost Wolf");
code.cache_spell_data(462854, "Skyfury");
code.cache_spell_data(192249, "Storm Elemental");
code.cache_spell_data(546, "Water Walking");
code.cache_spell_data(57994, "Wind Shear");
code.cache_spell_data(108271, "Astral Shift");
code.cache_spell_data(192063, "Gust of Wind");

code.cache_spell_data(382021, "Earthliving Weapon");
code.cache_spell_data(318038, "Flametongue Weapon");
code.cache_spell_data(33757, "Windfury Weapon");
code.cache_spell_data(462757, "Thunderstrike Ward");

code.cache_spell_data(974, "Earth Shield");
code.cache_spell_data(192106, "Lightning Shield");
code.cache_spell_data(52127, "Water Shield");


code.cache_spell_data(207399, "Ancestral Protection Totem");
code.cache_spell_data(192058, "Capacitor Totem");
code.cache_spell_data(2484, "Earthbind Totem");
code.cache_spell_data(198838, "Earthen Wall Totem");
code.cache_spell_data(51485, "Earthgrab Totem");
code.cache_spell_data(5394, "Healing Stream Totem");
code.cache_spell_data(108280, "Healing Tide Totem");
code.cache_spell_data(192222, "Liquid Magma Totem");
code.cache_spell_data(16191, "Mana Tide Totem");
code.cache_spell_data(98008, "Spirit Link Totem");
code.cache_spell_data(192077, "Wind Rush Totem");
code.cache_spell_data(8143, "Tremor Totem");
code.cache_spell_data(383013, "Poison Cleansing Totem");
code.cache_spell_data(383017, "Mana Spring Totem");
code.cache_spell_data(8512, "Windfury Totem");
code.cache_spell_data(383019, "Stoneskin Totem");
code.cache_spell_data(383015, "Tranquil Mind Totem");
--#endregion


--#region Warlock
code.cache_spell_data(104316, "Call Dreadstalkers");
code.cache_spell_data(119898, "Command Demon");
code.cache_spell_data(1714, "Curse of Tongues");	--y
code.cache_spell_data(702, "Curse of Weakness");	--y
code.cache_spell_data(334275, "Curse of Exhaustion");	--y

code.cache_spell_data(108416, "Dark Pact");
code.cache_spell_data(108503, "Grimoire of Sacrifice");
code.cache_spell_data(20707, "Soulstone");	--y
code.cache_spell_data(5697, "Unending Breath");	--y
code.cache_spell_data(104773, "Unending Resolve");
code.cache_spell_data(6201, "Create Healthstone");--y
code.cache_spell_data(29893, "Create Soulwell");	--y
code.cache_spell_data(126, "Eye of Kilrogg");--y
code.cache_spell_data(691, "Summon Felhunter");--y
code.cache_spell_data(688, "Summon Imp");--y
code.cache_spell_data(366222, "Summon Sayaad");--y
code.cache_spell_data(697, "Summon Voidwalker");	--y
code.cache_spell_data(1122, "Summon Infernal");
code.cache_spell_data(30146, "Summon Felguard");
code.cache_spell_data(205180, "Summon Darkglare");--y
code.cache_spell_data(48020, "Demonic Circle: Teleport");
code.cache_spell_data(111771, "Demonic Gateway");
code.cache_spell_data(19647, "Spell Lock");
code.cache_spell_data(265187, "Summon Demonic Tyrant");
code.cache_spell_data(698, "Ritual of Summoning");
--#endregion


--#region Warrior
code.cache_spell_data(386164, "Battle Stance");
code.cache_spell_data(386196, "Berserker Stance");
code.cache_spell_data(386208, "Defensive Stance");
code.cache_spell_data(6673, "Battle Shout");
code.cache_spell_data(100, "Charge");
code.cache_spell_data(97462, "Rallying Cry");
code.cache_spell_data(1160, "Demoralizing Shout");
code.cache_spell_data(184364, "Enraged Regeneration");
code.cache_spell_data(3411, "Intervene");
code.cache_spell_data(6552, "Pummel");
code.cache_spell_data(2565, "Shield Block");
code.cache_spell_data(871, "Shield Wall");
code.cache_spell_data(190456, "Ignore Pain");
code.cache_spell_data(6544, "Heroic Leap");
code.cache_spell_data(118038, "Die by the Sword");
code.cache_spell_data(12975, "Last Stand");
code.cache_spell_data(34428, "Victory Rush");
code.cache_spell_data(202168, "Impending Victory");

--#endregion


--#region Class Utilities (Mobility, Defensives, CC)
-- Mobility
code.cache_spell_data(1953, "Blink");
code.cache_spell_data(212653, "Shimmer");
code.cache_spell_data(189110, "Infernal Strike");
code.cache_spell_data(1850, "Dash");
code.cache_spell_data(106898, "Stampeding Roar");
code.cache_spell_data(58875, "Spirit Walk");
code.cache_spell_data(370665, "Rescue");
code.cache_spell_data(111400, "Burning Rush");

-- Defensives
code.cache_spell_data(108978, "Alter Time");
code.cache_spell_data(55342, "Mirror Image");
code.cache_spell_data(108281, "Ancestral Guidance");
code.cache_spell_data(192081, "Ironfur");
code.cache_spell_data(357170, "Time Dilation");
code.cache_spell_data(374227, "Zephyr");
code.cache_spell_data(586, "Fade");
code.cache_spell_data(51052, "Anti-Magic Zone");
code.cache_spell_data(49039, "Lichborne");
code.cache_spell_data(196555, "Netherwalk");

-- Crowd Control & Debuffs (Multiple)
code.cache_spell_data(207167, "Blinding Sleet");
code.cache_spell_data(179057, "Chaos Nova");
code.cache_spell_data(102793, "Ursol's Vortex");
code.cache_spell_data(102359, "Mass Entanglement");
code.cache_spell_data(358385, "Landslide");
code.cache_spell_data(372048, "Oppressing Roar");
code.cache_spell_data(122, "Frost Nova");
code.cache_spell_data(113724, "Ring of Frost");
code.cache_spell_data(31661, "Dragon's Breath");
code.cache_spell_data(116844, "Ring of Peace");
code.cache_spell_data(115750, "Blinding Light");
code.cache_spell_data(8122, "Psychic Scream");
code.cache_spell_data(30283, "Shadowfury");
code.cache_spell_data(46968, "Shockwave");
code.cache_spell_data(5246, "Intimidating Shout");

-- Crowd Control & Debuffs (Single)
code.cache_spell_data(108194, "Asphyxiate");
code.cache_spell_data(217832, "Imprison");
code.cache_spell_data(5211, "Mighty Bash");
code.cache_spell_data(33786, "Cyclone");
code.cache_spell_data(2637, "Hibernate");
code.cache_spell_data(360806, "Sleep Walk");
code.cache_spell_data(1513, "Scare Beast");
code.cache_spell_data(118, "Polymorph");
code.cache_spell_data(31589, "Slow");
code.cache_spell_data(853, "Hammer of Justice");
code.cache_spell_data(20066, "Repentance");
code.cache_spell_data(64044, "Psychic Horror");
code.cache_spell_data(9484, "Shackle Undead");
code.cache_spell_data(605, "Mind Control");
code.cache_spell_data(2094, "Blind");
code.cache_spell_data(6770, "Sap");
code.cache_spell_data(408, "Kidney Shot");
code.cache_spell_data(1833, "Cheap Shot");
code.cache_spell_data(51514, "Hex");
code.cache_spell_data(5782, "Fear");
code.cache_spell_data(710, "Banish");
code.cache_spell_data(107570, "Storm Bolt");
code.cache_spell_data(1715, "Hamstring");
--#endregion


--#region Skills
code.cache_spell_data(28596, "Alchemy");
code.cache_spell_data(818, "Cooking Fire");
code.cache_spell_data(29844, "Blacksmithing");
code.cache_spell_data(33359, "Cooking");
code.cache_spell_data(78670, "Archaeology");
code.cache_spell_data(13262, "Disenchant");
code.cache_spell_data(28029, "Enchanting");
code.cache_spell_data(30350, "Engineering");
code.cache_spell_data(45357, "Inscription");
code.cache_spell_data(28897, "Jewelcrafting");
code.cache_spell_data(32549, "Leatherworking");
code.cache_spell_data(51005, "Milling");
code.cache_spell_data(31252, "Prospecting");
code.cache_spell_data(53428, "Runeforging");
code.cache_spell_data(2656, "Smelting");
code.cache_spell_data(80451, "Survey");
code.cache_spell_data(26790, "Tailoring");
code.cache_spell_data(131474, "Fishing");
code.cache_spell_data(201891, "Undercurrent");

code.cache_spell_data(3273, "First Aid");
code.cache_spell_data(818, "Basic Campfire");
code.cache_spell_data(5504, "Conjure Water");
code.cache_spell_data(194174, "Skinning Journal");
code.cache_spell_data(271990, "Fishing Journal");
code.cache_spell_data(193290, "Herbalism Journal");
code.cache_spell_data(2656, "Mining Journal");
code.cache_spell_data(391113, "Overload Herbs");
code.cache_spell_data(391114, "Overload Elemental Deposit");
--#endregion

local cache_timer_stop = debugprofilestop();

ABGData.timing["CacheSpellData.lua"] = cache_timer_stop - cache_timer_start;
