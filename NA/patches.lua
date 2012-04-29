--------------------------------------------------------------------------------
-- patches.lua                                                                --
-- 2012-02-29  - Pyriel                                                       --
--                                                                            --
--This script contains tables of patch data, and in some cases names of patch --
--files that will be applied to the source ISO.                               --
--                                                                            --
--                                                                            --
--Version 1.6.xx  - 2012-03-01                                                --
--  #initial creation                                                         --
--  + Annallee Song                                                           --
--  + War Theme #1                                                            --
--  + War Theme #3                                                            --
--  + Chant                                                                   --
--  + Kindness Rune Glitch                                                    --
--  + Level 99 Recruit Bug                                                    --
--  + Tenzen Pass Monster patch                                               --
--  + Ryube Knife-throwing scenario patch                                     --
--  + Recipes Bugs                                                            --
--  + Blueprint Bugs                                                          --
--  + Sound Set Bug                                                           --
--  + Window Set Bug                                                          --
--  + Lamb Bug                                                                --
--  + Seed Bug                                                                --
--  + Farm Animals Bug                                                        --
--  + Chaco Bug                                                               --
--  + Matilda Gate Glitch                                                     --
--  + Inn Bug                                                                 --
--  + Untranslated Trade Gossip                                               --
--  + Castle Armory Potch Bug                                                 --
--  + GS1 Hero Name Bug                                                       --
--                                                                            --
--------------------------------------------------------------------------------

--Applies to file: /SLUS_009.58
patch_music = {
	--Fix Annallee's Song
	[0x827E0] = {
		0x93, 0x68, 0x00, 0x03, 0xA3, 0x89, 0x00, 0x01
	},

	--Fix War Theme #1
	[0x827B0] = {
		0xA6, 0x7F, 0x00, 0x06, 0x8E, 0x9D, 0x00, 0x01
	},

	--Fix War Theme #3
	[0x827A0] = {
		0x01, 0x08, 0x00, 0x00, 0x22, 0x87, 0x00, 0x02,
		0xA2, 0x9C, 0x00, 0x01, 0x01, 0x5A, 0x00, 0x00
	},

	--Fix Chant
	[0x827F0] = {
		0x25, 0x53, 0x00, 0x01, 0x00, 0x78, 0x00, 0x00,
		0x2D, 0x53, 0x00, 0x05, 0x2D, 0x83, 0x00, 0x01
	},
}

--Applies to file: /SLUS_009.58
patch_kindness_rune = {
	[0x1E170] = {
		0x21, 0x10, 0x43, 0x00, 0x21, 0x18, 0x40, 0x02,
		0x21, 0x18, 0x43, 0x00, 0xE8, 0x03, 0x62, 0x28
	}
}

--Applies to file: /SLUS_009.58
patch_level_99 = {
	[0x37B7C] = {
		0x10, 0x00, 0xA2, 0x83, 0xE8, 0x88, 0x02, 0x08,
		0x21, 0x10, 0x22, 0x02, 0x10, 0x00, 0xA2, 0x83
	}
}


--Applies to file: /CDROM/010_ARA/VA11.BIN
patch_tenzen_monsters = {
	--Name:  Minotaurus
	[0x31820] = {
		0x47, 0x19, 0x1E, 0x1F, 0x24, 0x11, 0x25, 0x22,
		0x25, 0x23, 0x00
	},

	--Name: Magus
	[0x34314] = {
		0x47, 0x11, 0x17, 0x25, 0x23, 0x00, 0x00, 0x00,
		0x00
	},

	--Name: Chimera
	[0x378F8] = {
		0x3D, 0x18, 0x19, 0x1D, 0x15, 0x22, 0x11, 0x00,
		0x00
	},

	--Add Chimera formations to encounter table.
	[0x28784] = {
		0xD4, 0x62, 0x13, 0x80, 0x7C, 0x63, 0x13, 0x80,
		0xF0, 0x62, 0x13, 0x80, 0x98, 0x63, 0x13, 0x80,
		0x0C, 0x63, 0x13, 0x80, 0x28, 0x63, 0x13, 0x80,
		0xB4, 0x63, 0x13, 0x80, 0x44, 0x63, 0x13, 0x80,
		0x44, 0x63, 0x13, 0x80, 0x60, 0x63, 0x13, 0x80
	}
}

--Applies to file: /CDROM/020_ARB/VB18.BIN
patch_knife_throwing = {
  [0x0050] = {
		0x07, 0x80, 0x03, 0x3C, 0x96, 0x98, 0x64, 0x94,
		0x21, 0x88, 0x02, 0x00, 0x42, 0x20, 0x04, 0x00,
		0x03, 0x00, 0x80, 0x14, 0x00, 0x00, 0x00, 0x00,
		0x01, 0x00, 0x04, 0x24, 0x00, 0x00, 0x00, 0x00,
		0x96, 0x98, 0x64, 0xA4
  }
}

--Applies to file:  /CDROM/080_ARH/VH01.BIN
patch_chaco = {
	[0x3084] = {
		0x73, 0x36, 0x1D, 0x54, 0x36, 0x1F, 0x54, 0x75,
		0x1F, 0x54, 0x58, 0x1F, 0x05, 0x00, 0x00, 0x00,
		0x05, 0x0F, 0x1E, 0x65, 0x04, 0x06, 0x05, 0x00,
		0x02, 0x00, 0x05, 0x03, 0x01, 0x00, 0x05, 0x03,
		0x03, 0x00, 0x05, 0x03, 0x00, 0x00, 0x05, 0x03,
		0x1E, 0x59, 0x00, 0x02, 0x08, 0x59, 0x00, 0x05,
		0x59, 0x00, 0x05, 0x49, 0x0A, 0x59, 0x00, 0x02,
		0x09, 0x05, 0x00, 0x06, 0x02, 0x1E, 0x59, 0x00,
		0x02, 0x0A, 0x59, 0x00, 0x05, 0x59, 0x00, 0x05,
		0x49, 0x0A, 0x1E, 0x02, 0x01, 0x36, 0x05, 0x00,
		0x00, 0x00, 0x05, 0x0F, 0x03, 0x00, 0x1E, 0x09,
		0x2D, 0x01, 0x09, 0x2D, 0x02, 0x09, 0x2D, 0x20,
		0x09, 0x2E, 0x08, 0x09, 0x2E, 0x01, 0x09, 0x2E,
		0x04, 0x18, 0x09, 0x03, 0x75, 0x05, 0x09, 0x02,
		0x02, 0x05, 0x06, 0x07, 0x02, 0x1E, 0x65, 0x04,
		0x06, 0x1E, 0x01, 0x01, 0x01, 0x1B, 0x40, 0x50,
		0x18, 0x01, 0x05, 0x06, 0x18, 0x01, 0x03, 0x70,
		0x03, 0x09, 0x00, 0x18, 0x09, 0x03, 0x71, 0x2B,
		0x01, 0x05, 0x30, 0x01, 0x00, 0x03, 0x02, 0x01,
		0x00, 0x08, 0x2E, 0x2B, 0x01, 0x04, 0x03, 0x01,
		0x03, 0x03, 0x09, 0x02, 0x2F, 0x18, 0x01, 0x03,
		0x72, 0x18, 0x09, 0x03, 0x73, 0x24, 0x20, 0x18,
		0x01, 0x03, 0x74, 0x2B, 0x01, 0x05, 0x36, 0x00,
		0x20, 0x05, 0x01, 0x03, 0x1C, 0x1E, 0x2B, 0x01,
		0x04, 0x45, 0x01, 0x0B, 0x02, 0x02, 0x28, 0x22,
		0x09, 0xB6, 0x01, 0x3E, 0x00, 0x58, 0x20, 0x00,
		0x00, 0xB1, 0x51, 0x0B, 0x01, 0x02, 0x28, 0xFF,
		0xFE, 0xFF, 0x01, 0x18, 0x09, 0x03, 0x78, 0x03,
		0x01, 0x03, 0x25, 0x08, 0x24, 0x10, 0xFF, 0xFE
	}

}

--Applies to file:  /CDROM/080_ARH/VH10.BIN
patch_lamb = {
	[0x9ACC] = { 0x06, 0x40, 0xFF, 0xFE	},
	[0x9E58] = { 0x06, 0x40, 0x65, 0x00 }
}

--Applies to file: /CDROM/090_ARI/VI11.BIN
patch_matilda_gate = {
	[0x4D47] = { 0xFF }
}

--Applies to file: /CDROM/110_ARK/VK19.BIN
patch_farm = {
	[0x1F0] = {
		0x2F, 0x1A, 0x62, 0x90, 0x1C, 0x19, 0x74, 0x8C,
		0x07, 0x00, 0x16, 0x34, 0x03, 0x00, 0x15, 0x34,
		0x23, 0x10, 0xA2, 0x02, 0x06, 0x10, 0x56, 0x00,
		0x00, 0x13, 0x02, 0x00, 0x25, 0xA0, 0x82, 0x02,
		0x30, 0x1A, 0x62, 0x90, 0x07, 0x00, 0x16, 0x34,
		0x23, 0x10, 0xA2, 0x02, 0x06, 0x10, 0x56, 0x00,
		0xC0, 0x13, 0x02, 0x00, 0x25, 0xA0, 0x82, 0x02,
		0x31, 0x1A, 0x62, 0x90, 0x0F, 0x00, 0x16, 0x34,
		0x04, 0x00, 0x13, 0x34, 0x23, 0x10, 0x62, 0x02,
		0x06, 0x10, 0x56, 0x00, 0x80, 0x14, 0x02, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x32, 0x1A, 0x62, 0x90,
		0x07, 0x00, 0x16, 0x34, 0x23, 0x10, 0xA2, 0x02,
		0x06, 0x10, 0x56, 0x00, 0x80, 0x15, 0x02, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x1C, 0x19, 0x74, 0xAC,
		0x3F, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00
	},

	[0x548]	= {
		0x2B, 0x1A, 0x62, 0x90, 0x1C, 0x19, 0x74, 0x8C,
		0x07, 0x00, 0x16, 0x34, 0x03, 0x00, 0x15, 0x34,
		0x23, 0x10, 0xA2, 0x02, 0x06, 0x10, 0x56, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x2C, 0x1A, 0x62, 0x90,
		0x07, 0x00, 0x16, 0x34, 0x23, 0x10, 0xA2, 0x02,
		0x06, 0x10, 0x56, 0x00, 0xC0, 0x10, 0x02, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x2D, 0x1A, 0x62, 0x90,
		0x07, 0x00, 0x16, 0x34, 0x23, 0x10, 0xA2, 0x02,
		0x06, 0x10, 0x56, 0x00, 0x80, 0x11, 0x02, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x2E, 0x1A, 0x62, 0x90,
		0x07, 0x00, 0x16, 0x34, 0x23, 0x10, 0xA2, 0x02,
		0x06, 0x10, 0x56, 0x00, 0x40, 0x12, 0x02, 0x00,
		0x25, 0xA0, 0x82, 0x02, 0x1C, 0x19, 0x74, 0xAC,
		0x3A, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00
	}
}

--Applies to /CDROM/130_SHOP/YADOYA*.BIN
patch_inn = {
	[0xADC] = { 0x00, 0x00, 0x00, 0x00 }
}

--Applies to /CDROM/130_SHOP/UWASA*.BIN
patch_trade_gossip = {
	--patches are too large and custom .  Applied from prepatched file.
}

--Applies to /CDROM/140_HONP/HDOUGUYA.BIN
patch_castle_armory = {
	--patch is somewhat large.  Applied from prepatched file.
}

--Applies to file: /CDROM/150_BPRG/BUFF0/BP0_AFT.BIN

--TODO:  UPDATE TO MATCH LATEST PATCHED BIN
patch_collectibles = {
	--Fix Blueprint Bug
	[0x2870] = { 0x01, 0x00, 0x02, 0x34 };
	[0x2898] = { 0x01, 0x00, 0x02, 0x34 };

	[0x28A0] = {
		0x10, 0x00, 0x82, 0x2C, 0x0D, 0x00, 0x40, 0x10,
		0x08, 0x00, 0x82, 0x2C, 0x05, 0x00, 0x40, 0x14,
		0x00, 0x00, 0x03, 0x34, 0x0C, 0x00, 0x82, 0x2C,
		0x02, 0x00, 0x40, 0x14, 0xFC, 0xFF, 0x03, 0x24,
		0x04, 0x00, 0x03, 0x34, 0xFA, 0x01, 0x82, 0x96,
		0x23, 0x18, 0x83, 0x00, 0x07, 0x10, 0x62, 0x00,
		0x01, 0x00, 0x42, 0x30, 0x15, 0x00, 0x40, 0x14,
		0x01, 0x00, 0x02, 0x34, 0xF3, 0xFF, 0x63, 0x26
	},

	--Fix Window Set Bug
	[0x28EC] = { 0xE4, 0x06, 0x82, 0x92 },
	[0x2900] = { 0x01, 0x00, 0x02, 0x34 },

	--Fix Sound Set Bug
	[0x2910] = { 0xE5, 0x06, 0x83, 0x92 },
	[0x2924] = { 0x01, 0x00, 0x02, 0x34 },

	--Fix Recipe Bugs
	[0x2998] = { 0xD5, 0xFF, 0x45, 0x24 },
	[0x29E4] = { 0x21, 0x80, 0x74, 0x02 },
	[0x2A00] = { 0x07, 0x10, 0x42, 0x02 },
	[0x2A34] = { 0xE0, 0xFF, 0x45, 0x24 },
	[0x2A80] = { 0x21, 0x80, 0x74, 0x02 },
	[0x2A9C] = { 0x07, 0x18, 0x43, 0x02 }

	--Temporary signature for testing.  REMOVE
--[[	,[0x3118] = {
		0x0B, 0x53, 0x03, 0x0C, 0xFF, 0x00, 0x10, 0x34,
		0x00, 0x1A, 0x02, 0x00, 0x23, 0x18, 0x62, 0x00,
		0xC2, 0x1B, 0x03, 0x00, 0x10, 0x00, 0xA2, 0x93,
		0xFF, 0x00, 0x63, 0x30, 0x04, 0x00, 0x70, 0x14,
		0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x63, 0x24,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00
	} ]]--
}

--Applies to file: /CDROM/270_BOOT/G1LOAD.BIN
patch_gs1_hero_name = {
	[0x31BC] = {
		0x21, 0x38, 0x00, 0x00, 0x21, 0x10, 0x87, 0x00,
		0x00, 0x00, 0x43, 0x90, 0x01, 0x00, 0xE7, 0x24,
		0x10, 0x00, 0x60, 0x10, 0x21, 0x10, 0x03, 0x00,
		0xF0, 0xFF, 0x68, 0x24, 0x1B, 0x00, 0x08, 0x2D,
		0x0C, 0x00, 0x00, 0x15, 0xD5, 0xFF, 0x68, 0x24,
		0x1A, 0x00, 0x08, 0x2D, 0x09, 0x00, 0x00, 0x15,
		0x10, 0x00, 0x62, 0x24, 0xBB, 0xFF, 0x68, 0x24,
		0x13, 0x00, 0x08, 0x2D, 0x05, 0x00, 0x00, 0x15,
		0x53, 0x00, 0x62, 0x24, 0xA8, 0xFF, 0x68, 0x24,
		0x15, 0x00, 0x08, 0x2D, 0x02, 0x00, 0x00, 0x15,
		0x10, 0x00, 0x62, 0x24, 0x00, 0x00, 0xA2, 0xA0,
		0x2A, 0x10, 0xE6, 0x00, 0xE9, 0xFF, 0x40, 0x14
	}
}

patch_luca_party_change = {
	[0x2FD0] = {
		0x09, 0xF8, 0x20, 0x02,	0x21, 0x20, 0x00, 0x02,
		0x0E, 0x00, 0x40, 0x10,	0x00, 0x00, 0x00, 0x00,
		0x09, 0xF8, 0x20, 0x02,	0x21, 0x20, 0x00, 0x02,
		0x01, 0x00, 0x03, 0x34,	0x09, 0x00, 0x43, 0x10,
		0x21, 0x20, 0x00, 0x02,	0x09, 0xF8, 0x20, 0x02,
		0x00, 0x00, 0x00, 0x00, 0x26, 0x00, 0x04, 0x34,
		0x09, 0xF8, 0xA0, 0x02, 0x21, 0x28, 0x40, 0x00,
		0x21, 0x20, 0x00, 0x02, 0x09, 0xF8, 0x60, 0x02,
		0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x10, 0x26,
		0x06, 0x00, 0x02, 0x2A, 0xEC, 0xFF, 0x40, 0x14,
		0x00, 0x00, 0x00, 0x00, 0x25, 0xCE, 0x01, 0x0C,
		0x00, 0x00, 0x00, 0x00, 0x25, 0x00, 0x04, 0x34
	}
}

patchreq = {
	{ name="Music Fix",										file="SLUS_009.58",		patch=patch_music },
	{ name="Kindness Rune Fix",								file="SLUS_009.58",		patch=patch_kindness_rune },
	{ name="Recruit @ Level 99 Fix",						file="SLUS_009.58",		patch=patch_level_99 },
	{ name="Tenzen Pass Monster Fix",						file="VA11.BIN",		patch=patch_tenzen_monsters },
	{ name="Knife-throwing Scene Fix",						file="VB18.BIN",		patch=patch_knife_throwing },
	{ name="Chaco Joins @ Level 1 Fix",						file="VH01.BIN",		patch=patch_chaco },
	{ name="Unicorn Woods Lamb Fix",						file="VH10.BIN",		patch=patch_lamb },
	{ name="Matilda Gate Fix",								file="VI11.BIN",		patch=patch_matilda_gate },
	{ name="Farm Seeds & Stock Fix",						file="VK19.BIN",		patch=patch_farm },
	{ name="Inn Free Restoration Fix Part 1",				file="YADOYA1.BIN",		patch=patch_inn },
	{ name="Inn Free Restoration Fix Part 2",				file="YADOYA2.BIN",		patch=patch_inn },
	{ name="Trade Gossip Translation Part 1",				file="UWASA1.BIN",		patch=nil },
	{ name="Trade Gossip Translation Part 2",				file="UWASA2.BIN",		patch=nil },
	{ name="Collectibles (Recipes, Blueprints etc.) Fix",	file="BP0_AFT.BIN",		patch=patch_collectibles },
	{ name="Castle Armory Potch Overflow Fix",				file="HDOUGUYA.BIN",	patch=nil },
	{ name="Suikoden Hero Name Fix",						file="G1LOAD.BIN",		patch=patch_gs1_hero_name },
	{ name="Scroll Shop Antiques Bug",						file="FUDAZUK.BIN",		patch=nil },
	{ name="Rune Unite Bug",								file="BP0_FST.BIN",		patch=nil },
	{ name="Rune Unite Bug",								file="BP0_SEC.BIN",		patch=nil },
	{ name="Luca Party Change Bug",							file="PARTYCE1.BIN",	patch=patch_luca_party_change }
}

patch_circlet = true;

patch_godspeed = true;

patch_gozz = true;
patch_gozz_type = "MINOTAUR";

patch_gozz_data = {
	["GOZU"] = 		{ 0x41, 0x1F, 0x2A, 0x25, 0x00 },
	["MINOTAUR"] =	{ 0x47, 0x19, 0x1E, 0x1F, 0x24, 0x11, 0x25, 0x22, 0x00 }
}


circlet_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN", "VK06.BIN",
	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "BOOK.BIN",
	"FUDAZUK.BIN", "HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN",
	"MOGURA.BIN", "PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN",
	"REST.BIN", "SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "VB19PIN.BIN",
	"VG08PIN.BIN", "BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "BOGU.BIN"
}

--60 out of 1,100 files require the godspeed patch.
godspeed_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN", "VK06.BIN",
	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "FUDAZUK.BIN",
	"HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN", "MOGURA.BIN",
	"PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN", "REST.BIN",
	"SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "TANTEI.BIN","VB19PIN.BIN",
	"VG08PIN.BIN", "BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "EMBL.BIN"
}

--61 out of 1,100 files require the gozz patch.
gozz_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VG11.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN",
	"VK06.BIN",	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "FUDAZUK.BIN",
	"HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN", "MOGURA.BIN",
	"PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN", "REST.BIN",
	"SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "VB19PIN.BIN", "VG08PIN.BIN",
	"BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "EMBL.BIN", "MAGI.BIN",
}

function PatchRequested(name)
	local i, v;
	for i, v in ipairs(patchreq) do
		if(v.file == name) then
			return true;
		end
	end
	return false;
end

function ApplyPatch(patch, file)
	local i, j, v, patchbyte;
	for j, v in pairs(patch) do
		for i, patchbyte in ipairs(v) do
			file[j + i - 1] = patchbyte;
		end
	end
end

function ApplyPatches(name, deFile)
	local i, v;
	local touched = false;
	local file = Buffer(true);
	for i, v in ipairs(patchreq) do
		if(v.file == name) then
			if(v.patch == nil) then
				if(touched == true) then error("Cannot replace file from HDD after another patch has been applied.  Check patch order.") end
				print("PATCHER: Loading " .. name .. " from pre-patched file on HDD for " .. v.name);
				local tmp = Input(name);
				file:copyfrom(tmp);
				touched = true;
			else
				if(touched == false) then
					print("PATCHER:  Loading " .. name .. " from source disc.");
					local tmp = cdfile(deFile);
					file:copyfrom(tmp);
					touched = true;
				end
				print("PATCHER: Updating " .. name .. " with " .. v.name);
				ApplyPatch(v.patch, file);
			end
		end
	end
	if(touched == false) then
		print("No patches found for file " .. name .. " copying from source disc.");
		file = cdfile(deFile);
	end
	return file;
end

function IsGodspeedFile(name)
	for i, v in ipairs(godspeed_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyGodspeedPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x4E
		 and file[i + 1] == 0x22
		 and file[i + 2] == 0x25
		 and file[i + 3] == 0x15
		 and file[i + 4] == 0x10
		 and file[i + 5] == 0x42
		 and file[i + 6] == 0x1F
		 and file[i + 7] == 0x1C
		 and file[i + 8] == 0x29) then
			file:wseek(i)
			file:writeU32(0x23141F41);
			file:writeU32(0x14151520);
			file:writeU8(0);
			i = file:seek(file:wtell());
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Godspeed Patch to "..name); end
end

function IsGozzFile(name)
	for i, v in ipairs(gozz_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyGozzPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x41
		 and file[i + 1] == 0x1F
		 and file[i + 2] == 0x2A
		 and file[i + 3] == 0x2A
		 and file[i + 4] == 0x00) then
			local tmp_patch = { [i] = patch_gozz_data[patch_gozz_type] };
			ApplyPatch(tmp_patch, file);
			i = i + 5;
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Gozz Rune Patch to "..name); end
end

function IsCircletFile(name)
	for i, v in ipairs(circlet_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyCircletPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x3D
		 and file[i + 1] == 0x19
		 and file[i + 2] == 0x22
		 and file[i + 3] == 0x13
		 and file[i + 4] == 0x25
		 and file[i + 5] == 0x22
		 and file[i + 6] == 0x15
		 and file[i + 7] == 0x24
		 and file[i + 8] == 0x00) then
			file:wseek(i)
			file:writeU32(0x1322193D);
			file:writeU32(0x0024151C);
			file:writeU8(0);
			i = file:seek(file:wtell());
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Circlet Patch to "..name); end
end
