game 'gta5'
fx_version 'cerulean'
lua54 'yes'

client_scripts {
    'config.lua',
    'client/**/*.lua'
}

ui_page 'html/index.html'
files {
    'html/*.html',
    'html/js/*.js',
    'html/css/*.css',
	'html/img/*.png',
    'html/img/**/*.png'
}

exports {
	'getMenuIsOpen',
    'Update',
    'Options'
}

data_file 'AUDIO_WAVEPACK' 'audio'
files {
	'audio/lmg_combat.awc',
	'audio/lmg_mg_player.awc',
	'audio/mgn_sml_am83_vera.awc',
	'audio/mgn_sml_am83_verb.awc',
	'audio/mgn_sml_sc__l.awc',
	'audio/ptl_50cal.awc',
	'audio/ptl_combat.awc',
	'audio/ptl_pistol.awc',
	'audio/ptl_px4.awc',
	'audio/ptl_rubber.awc',
	'audio/sht_bullpup.awc',
	'audio/sht_pump.awc',
	'audio/smg_micro.awc',
	'audio/smg_smg.awc',
	'audio/snp_heavy.awc',
	'audio/snp_rifle.awc',
	'audio/spl_grenade_player.awc',
	'audio/spl_minigun_player.awc',
	'audio/spl_prog_ar_player.awc',
	'audio/spl_railgun.awc',
	'audio/spl_rpg_player.awc',
	'audio/spl_tank_player.awc'
}