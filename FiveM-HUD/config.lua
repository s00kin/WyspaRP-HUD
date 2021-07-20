Config = {}
Config = {
	Directions = {
		[0] = 'BLANK',
		[1] = 'FORWARD',
		[2] = 'BACK',
		[3] = 'LEFT',
		[4] = 'RIGHT',
		[5] = 'SLIPROAD_LEFT',
		[6] = 'SLIPROAD_RIGHT',
		[7] = 'DIAGONAL_LEFT',
		[8] = 'DIAGONAL_RIGHT',
		[9] = 'MERGE_LEFT',
		[10] = 'MERGE_RIGHT',
		[11] = 'U_TURN'
	},
	Minimap = {
		Rect = {
			['minimap'] = {
				Pos = {
					x = -0.0045,
					y = 0.002
				},
				Size = {
					x = 0.15,
					y = 0.188888
				}
			},
			['minimap_mask'] = {
				Pos = {
					x = 0.02,
					y = 0.032
				},
				Size = {
					x = 0.111,
					y = 0.159
				}
			},
			['minimap_blur'] = {
				Pos = {
					x = -0.03,
					y = 0.022
				},
				Size = {
					x = 0.266,
					y = 0.237
				}
			}
		},
		Round = {
			['minimap'] = {
				Pos = {
					x = -0.019,
					y = -0.020
				},
				Size = {
					x = 0.183,
					y = 0.32
				}
			},
			['minimap_mask'] = {
				Pos = {
					x = -0.02,
					y = -0.022
				},
				Size = {
					x = 0.183,
					y = 0.32
				}
			},
			['minimap_blur'] = {
				Pos = {
					x = -0.018,
					y = 0.0
				},
				Size = {
					x = 0.256,
					y = 0.337
				}
			}
		},
		RoundVehicle = {
			['minimap'] = {
				Pos = {
					x = -0.019,
					y = -0.020
				},
				Size = {
					x = 0.183,
					y = 0.32
				}
			},
			['minimap_mask'] = {
				Pos = {
					x = -0.02,
					y = -0.022
				},
				Size = {
					x = 0.183,
					y = 0.32
				}
			},
			['minimap_blur'] = {
				Pos = {
					x = -0.018,
					y = 0.0
				},
				Size = {
					x = 0.256,
					y = 0.337
				}
			}
		},
		Bigmap = {
			['bigmap'] = {
				Pos = {
					x = 0.0175,
					y = -0.01
				},
				Size = {
					x = 0.364,
					y = 0.460416666
				}
			},
			['bigmap_mask'] = {
				Pos = {
					x = 0.17,
					y = -0.051
				},
				Size = {
					x = 0.176,
					y = 0.395
				}
			},
			['bigmap_blur'] = {
				Pos = {
					x = 0.00,
					y = -0.024
				},
				Size = {
					x = 0.262,
					y = 0.464
				}
			}
		}
	},
	Zones = {
		['AIRP'] = 'Los Santos International Airport',
		['ALAMO'] = 'Alamo Sea',
		['ALTA'] = 'Alta',
		['ARMYB'] = 'Fort Zancudo',
		['BANHAMC'] = 'Banham Canyon Dr',
		['BANNING'] = 'Banning',
		['BEACH'] = 'Vespucci Beach',
		['BHAMCA'] = 'Banham Canyon',
		['BRADP'] = 'Braddock Pass',
		['BRADT'] = 'Braddock Tunnel',
		['BURTON'] = 'Burton',
		['CALAFB'] = 'Calafia Bridge',
		['CANNY'] = 'Raton Canyon',
		['CCREAK'] = 'Cassidy Creek',
		['CHAMH'] = 'Chamberlain Hills',
		['CHIL'] = 'Vinewood Hills',
		['CHU'] = 'Chumash',
		['CMSW'] = 'Chiliad Mountain State Wilderness',
		['CYPRE'] = 'Cypress Flats',
		['DAVIS'] = 'Davis',
		['DELBE'] = 'Del Perro Beach',
		['DELPE'] = 'Del Perro',
		['DELSOL'] = 'La Puerta',
		['DESRT'] = 'Grand Senora Desert',
		['DOWNT'] = 'Downtown',
		['DTVINE'] = 'Downtown Vinewood',
		['EAST_V'] = 'East Vinewood',
		['EBURO'] = 'El Burro Heights',
		['ELGORL'] = 'El Gordo Lighthouse',
		['ELYSIAN'] = 'Elysian Island',
		['GALFISH'] = 'Galilee',
		['GOLF'] = 'GWC and Golfing Society',
		['GRAPES'] = 'Grapeseed',
		['GREATC'] = 'Great Chaparral',
		['HARMO'] = 'Harmony',
		['HAWICK'] = 'Hawick',
		['HORS'] = 'Vinewood Racetrack',
		['HUMLAB'] = 'Humane Labs and Research',
		['ISHEIST'] = 'Cayo Perico',
		['JAIL'] = 'Bolingbroke Penitentiary',
		['KOREAT'] = 'Little Seoul',
		['LACT'] = 'Land Act Reservoir',
		['LAGO'] = 'Lago Zancudo',
		['LDAM'] = 'Land Act Dam',
		['LEGSQU'] = 'Legion Square',
		['LMESA'] = 'La Mesa',
		['LOSPUER'] = 'La Puerta',
		['MIRR'] = 'Mirror Park',
		['MORN'] = 'Morningwood',
		['MOVIE'] = 'Richards Majestic',
		['MTCHIL'] = 'Mount Chiliad',
		['MTGORDO'] = 'Mount Gordo',
		['MTJOSE'] = 'Mount Josiah',
		['MURRI'] = 'Murrieta Heights',
		['NCHU'] = 'North Chumash',
		['NOOSE'] = 'N.O.O.S.E',
		['OCEANA'] = 'Pacific Ocean',
		['PALCOV'] = 'Paleto Cove',
		['PALETO'] = 'Paleto Bay',
		['PALFOR'] = 'Paleto Forest',
		['PALHIGH'] = 'Palomino Highlands',
		['PALMPOW'] = 'Palmer-Taylor Power Station',
		['PBLUFF'] = 'Pacific Bluffs',
		['PBOX'] = 'Pillbox Hill',
		['PROCOB'] = 'Procopio Beach',
		['RANCHO'] = 'Rancho',
		['RGLEN'] = 'Richman Glen',
		['RICHM'] = 'Richman',
		['ROCKF'] = 'Rockford Hills',
		['RTRAK'] = 'Redwood Lights Track',
		['SANAND'] = 'San Andreas',
		['SANCHIA'] = 'San Chianski Mountain Range',
		['SANDY'] = 'Sandy Shores',
		['SKID'] = 'Mission Row',
		['SLAB'] = 'Stab City',
		['STAD'] = 'Maze Bank Arena',
		['STRAW'] = 'Strawberry',
		['TATAMO'] = 'Tataviam Mountains',
		['TERMINA'] = 'Terminal',
		['TEXTI'] = 'Textile City',
		['TONGVAH'] = 'Tongva Hills',
		['TONGVAV'] = 'Tongva Valley',
		['VCANA'] = 'Vespucci Canals',
		['VESP'] = 'Vespucci',
		['VINE'] = 'Vinewood',
		['WINDF'] = 'Ron Alternates Wind Farm',
		['WVINE'] = 'West Vinewood',
		['ZANCUDO'] = 'Zancudo River',
		['ZP_ORT'] = 'Port of South Los Santos',
		['ZQ_UAR'] = 'Davis Quartz'
	},
	Directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N' },
	CustomStreets = {
		{ start_x = 296.66, start_y = -237.64, end_x = 354.17, end_y = -182.28, name = 'Urzędnicza Street' },
		{ start_x = 229.6842, start_y = -2178.7263, end_x = 478.8938, end_y = -1959.4221, name = 'Pope John Paul II Street' }
	},
     IsWyspa = true -- discord.gg/sokin
}