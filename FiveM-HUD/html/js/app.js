var defaultOptions = {
	pos: {
		freeroam: {
			['health']: {'left': '-2%', 'top': 'auto', 'bottom': '-2%'},
			['armor']: {'left': '10%', 'top': 'auto', 'bottom': '-2%'},
			['hunger']: {'left': '22%', 'top': 'auto', 'bottom': '-2%'},
			['water']: {'left': '34%', 'top': 'auto', 'bottom': '-2%'},
			['voice']: {'left': '46%', 'top': 'auto', 'bottom': '-2%'},
			['oxygen']: {'left': '58%', 'top': 'auto', 'bottom': '-2%'},
			['stamina']: {'left': '70%', 'top': 'auto', 'bottom': '-2%'},
			['drunk']: {'left': '82%', 'top': 'auto', 'bottom': '-2%'}
		},

		minimap: {
			['health']: {'left': '5%', 'top': '12%', 'bottom': 'auto'},
			['armor']: {'left': '13%', 'top': '4%', 'bottom': 'auto'},
			['hunger']: {'left': '22%', 'top': '-2%', 'bottom': 'auto'},
			['water']: {'left': '32%', 'top': '-6%', 'bottom': 'auto'},
			['voice']: {'left': '43%', 'top': '-7.5%', 'bottom': 'auto'},
			['oxygen']: {'left': '54%', 'top': '-7%', 'bottom': 'auto'},
			['stamina']: {'left': '64.5%', 'top': '-3%', 'bottom': 'auto'},
			['drunk']: {'left': '74%', 'top': '3%', 'bottom': 'auto'}
		},

		bigmap: {
			['health']: {'left': '-7%', 'top': '14%', 'bottom': 'auto'},
			['armor']: {'left': '-7%', 'top': '22%', 'bottom': 'auto'},
			['hunger']: {'left': '-7%', 'top': '30%', 'bottom': 'auto'},
			['water']: {'left': '-7%', 'top': '38%', 'bottom': 'auto'},
			['voice']: {'left': '-7%', 'top': '46%', 'bottom': 'auto'},
			['oxygen']: {'left': '-7%', 'top': '54%', 'bottom': 'auto'},
			['stamina']: {'left': '-7%', 'top': '62%', 'bottom': 'auto'},
			['drunk']: {'left': '-7%', 'top': '70%', 'bottom': 'auto'}
		}
	},

	colors: {
		['health']: '#ff0000',
		['armor']: '#43bd33',
		['hunger']: '#ff7500',
		['water']: '#00a1ff',
		['voice']: '#7100c7',
		['oxygen']: '#2b36cb',
		['stamina']: '#f6ff00',
		['drunk']: '#f7498d'
	}
};

var wheel = {
	style: {
		sizePx: 600,
		slices: {
			default: { fill: '#000000', stroke: '#000000', ['stroke-width']: 2, opacity: 0.60 },
			hover: { fill: '#ff8000', stroke: '#000000', ['stroke-width']: 2, opacity: 0.80 },
			selected: { fill: '#ff8000', stroke: '#000000', ['stroke-width']: 2, opacity: 0.80 }
		},
		titles: {
			default: { fill: '#ffffff', stroke: 'none', font: 'Helvetica', ['font-size']: 16, ['font-weight']: 'bold' },
			hover: { fill: '#ffffff', stroke: 'none', font: 'Helvetica', ['font-size']: 16, ['font-weight']: 'bold' },
			selected: { fill: '#ffffff', stroke: 'none', font: 'Helvetica', ['font-size']: 16, ['font-weight']: 'bold' }
		},
		icons: {
			width: 32,
			height: 32
		}
	},
	cfg: {
		navAngle: 285,
		minRadiusPercent: 0.6,
		maxRadiusPercent: 0.9
	}
};

var monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
var defaultAlign = {x: 0.0, y: 0.0, width: 351, height: 345, a: 1.777777777777778};
var bigAlign = {width: 643, height: 456};
var defaultSize = 16.0;

var app;
class UI {
    constructor(opt) {
		this.options = opt || defaultOptions;
		this.labels = {
			['health']: 'życia',
			['armor']: 'pancerza',
			['hunger']: 'głodu',
			['water']: 'wody',
			['voice']: 'głosu',
			['oxygen']: 'tlenu',
			['stamina']: 'wytrzymałości',
			['drunk']: 'upojenia'
		};

        this.selected = 'health',
        this.mode = 'freeroam';
		this.position = defaultAlign;
		this.rpmScale = 0;
		this.cruiseControlled = false;
		this.seatBelt = false;
		this.inVehicle = false;
		this.lastVoiceVehicle = false;
		this.lastVoicePress = false;
		this.ready = false;
		this.axonTimer = null;
		this.restoreAxon = false;
		this.restoreGps = false;
		this.restoreRadio = false;
		this.keepTicket = false;
		this.currentSize = defaultSize;
		this.wheelPtr = null;
		this.wheelKey = null;
		this.wheelEvt = false;
        this.health = new ProgressBar.Circle(health, {strokeWidth: 10, easing: 'easeInOut', duration: 100, color: this.options.colors.health});
        this.armor = new ProgressBar.Circle(armor, {strokeWidth: 10, easing: 'easeInOut', duration: 100, color: this.options.colors.armor});
        this.hunger = new ProgressBar.Circle(hunger, {strokeWidth: 10, easing: 'easeInOut', duration: 1000, color: this.options.colors.hunger});
        this.thirst = new ProgressBar.Circle(water, {strokeWidth: 10, easing: 'easeInOut', duration: 1000, color: this.options.colors.water});
        this.voice = new ProgressBar.Circle(voice, {strokeWidth: 10, easing: 'easeInOut', duration: 1000, color: this.options.colors.voice})
        this.oxygen = new ProgressBar.Circle(oxygen, {strokeWidth: 10, easing: 'easeInOut', duration: 100, color: this.options.colors.oxygen})
        this.stamina = new ProgressBar.Circle(stamina, {strokeWidth: 10, easing: 'easeInOut', duration: 100, color: this.options.colors.stamina})
		this.drunk = new ProgressBar.Circle(drunk, {strokeWidth: 10, easing: 'easeInOut', duration: 100, color: this.options.colors.drunk})
    }

	init() {
        $(document).keyup(function(e) {
            if (e.key == 'Escape') {
				if($(".options").css("opacity") != 0.0) {
					$(".options").css("opacity", "0.00");
					$.post('https://Radar/focus', JSON.stringify({status: false}));
					window.localStorage.setItem('WRP_ui', JSON.stringify(app.options));
				} else if(this.wheelPtr) {
					this.disableWheel();
				}
            } else if (this.wheelKey !== null && e.key == this.wheelKey) {
				this.disableWheel();
			}
        });

		$('.circle').click(function() {
			app.selected = this.id;
			$('.panel-header').html('Zmieniasz kolor wskaźnika ' + app.labels[this.id])
		});

		$('#defaults').click(function() {
			app.defaults();
		});

        $('.circle').draggable({
            revert: 'invalid'
        });

        $('.circle').droppable({
            current: this.id,
            drop: function(event, ui) {
                var id = $(ui.draggable).attr('id');
                var val = app.options.pos[app.mode][id];
                var val2 = app.options.pos[app.mode][this.id];
    
                app.options.pos[app.mode][id] = val2;
                app.options.pos[app.mode][this.id] = val;
    
                $(this).css({
                    'transition': '0.5s left linear'
                })
                app.rebuild(app.mode);
            }
        });

		this.rebuild('freeroam');
		this.ready = true;
	}

	description(label, name, description) {
		if(!name) {
			$('#description img').attr('src', 'img/gps_0.png');
		} else if(!isNaN(parseFloat(name))) {
			$('#description img').attr('src', 'img/weapons/' + name + '.png');
		} else {
			$('#description img').attr('src', 'img/items/' + name + '.png');
		}

		var text = label || '';
		if(description) {
			text += '<br/>' + description;
		}
		$("#description div").html(text);
	}

	wheel(data) {
		$("#items").css('width', wheel.style.sizePx + "px");
		$("#items").css('height', wheel.style.sizePx + "px");
		$("#items").css('marginTop', (($(window).height() - wheel.style.sizePx) / 2) + "px");

		this.wheelPtr = new wheelnav('items', null);
		this.wheelPtr.clickModeRotate = false;
		this.wheelPtr.slicePathFunction = slicePath().DonutSlice;
		this.wheelPtr.slicePathCustom = slicePath().DonutSliceCustomization();

		this.wheelPtr.navAngle = wheel.cfg.navAngle;
		this.wheelPtr.slicePathCustom.minRadiusPercent = wheel.cfg.minRadiusPercent;
		this.wheelPtr.slicePathCustom.maxRadiusPercent = wheel.cfg.maxRadiusPercent;

		this.wheelPtr.sliceInitPathCustom = this.wheelPtr.slicePathCustom;
		this.wheelPtr.sliceHoverPathCustom = this.wheelPtr.slicePathCustom;
		this.wheelPtr.sliceSelectedPathCustom = this.wheelPtr.slicePathCustom;

		this.wheelPtr.slicePathAttr = wheel.style.slices.default;
		this.wheelPtr.sliceHoverAttr = wheel.style.slices.hover;
		this.wheelPtr.sliceSelectedAttr = wheel.style.slices.selected;
		this.wheelPtr.titleWidth = wheel.style.icons.width;
		this.wheelPtr.titleHeight = wheel.style.icons.height;
		this.wheelPtr.titleAttr = wheel.style.titles.default;
		this.wheelPtr.titleHoverAttr = wheel.style.titles.hover;
		this.wheelPtr.titleSelectedAttr = wheel.style.titles.selected;

		var items = [];
		for(var value of data.labels) {
			if(!isNaN(parseFloat(value))) {
				items.push('imsrc:img/weapons/' + value + '.png');
			} else {
				items.push('imsrc:img/items/' + value + '.png');
			}
		}

		this.wheelPtr.createWheel(items);
		for(var j = 0; j < this.wheelPtr.navItems.length; j++) {
			this.wheelPtr.navItems[j].selected = false;
			this.wheelPtr.navItems[j].navSlice.mouseover(function () {
				if(!app.wheelEvt) {
					app.wheelEvt = true;
					$.post('https://Radar/shortcut', JSON.stringify({value: data.commands[j]}));
					setTimeout(app.disableWheel, 500);
				}
			});
			this.wheelPtr.navItems[j].navTitle.mouseover(function () {
				if(!app.wheelEvt) {
					app.wheelEvt = true;
					$.post('https://Radar/shortcut', JSON.stringify({value: data.commands[j]}));
					setTimeout(app.disableWheel, 500);
				}
			});
		}

		this.wheelPtr.refreshWheel();
		this.wheelKey = data.key;
		$('.wheel').css('opacity', 1.0);
	}

	disableWheel() {
		$('.wheel').css('opacity', 0.0);
		app.wheelPtr.removeWheel();
		app.wheelPtr = null;

		app.wheelEvt = false;
		$.post('https://Radar/focus', JSON.stringify({status: false, sound: true}));
	}

    warn(name, value) {
        if (value <= 0.10) {
            $('#' + name).css(
                {'animation': 'pulse-red 2s infinite'}
            )
        } else {
            $('#' + name).css({'animation': ''})
        }
    }

	hide() {
		if($('.axon').is(':visible')) {
			this.restoreAxon = true;
			$('.axon').hide();
		}

		if($('.gps').is(':visible')) {
			this.restoreGps = true;
			$('.gps').hide();
		}

		if($('.radio').is(':visible')) {
			this.restoreRadio = true;
			$('.radio').hide();
		}

		$('.container').hide();
		$('.inventory').hide();

		if(this.keepTicket) {
			$('.ticket').css('opacity', 0.0);
			this.keepTicket = false;
		}
	}

	show() {
		if(this.restoreAxon) {
			this.restoreAxon = false;
			$('.axon').show();
		}

		if(this.restoreGps) {
			this.restoreGps = false;
			$('.gps').show();
		}

		if(this.restoreRadio) {
			this.restoreRadio = false;
			$('.radio').show();
		}

		$('.container').show();
		$('.inventory').show();
		$('.ticket').css('opacity', 1.0);
	}

	defaults() {
		this.options = defaultOptions;
		for(var key in defaultOptions.colors) {
			document.querySelector('#' + key + ' > svg > path:last-child').setAttribute("stroke", defaultOptions.colors[key])
		}

		window.localStorage.setItem('WRP_ui', JSON.stringify(this.options));
		this.rebuild(this.mode);
	}

	align(position) {
		if(position.x != this.position.x || position.y != this.position.y || position.width != this.position.width || position.height != this.position.height || position.a != this.position.a) {
			var realWidth = position.width / position.a * defaultAlign.a
			$('.container').css({'top': position.y, 'left': position.x, 'width': realWidth, 'height': position.height});
			this.position = position;
			this.rebuild(this.mode);
		}
	}

	disableVehicle() {
		$('#speed').removeClass('cruise').html('');
		$('#rpm').removeClass('high').html('');
		$('#distance').html('');
		$('#gear').html('');
		$('#belt').removeClass('active').hide();
		$('#direction img').attr('src', 'img/gps_0.png');
	}

	inventory(add, item, count) {
		var item = $('<div>' + (add ? '+' : '-') + count + ' ' + (item.label ? item.label : item.name) + '</div>');
		$('.inventory').append(item);

		$(item).delay(5000).fadeOut(1000, function() {
			item.remove();
		})
	}

    rebuild(val) {
        this.mode = val;
		$('.circle').hide();
		$('.compass').hide();

		$('.map').hide();
		$('.map').removeClass('big');
		this.disableVehicle();

		var pairs = []; // build pairs cache
		for (var key in defaultOptions.pos[this.mode]) {
			var value = defaultOptions.pos[this.mode][key];
			pairs.push(value['top'] + '_' + value['left'] + '_' + value['bottom']);
		}

		var opt = this.options.pos[this.mode];
		for (var key in opt) {
			var value = opt[key];
			if (pairs.indexOf(value['top'] + '_' + value['left'] + '_' + value['bottom']) === -1) {
				opt = defaultOptions.pos[this.mode];
				this.options.pos[this.mode] = opt;
				break;
			}
		}

        for (var key in opt) { // build target ui
			var value = opt[key];
            $('#' + key).show();
            $('#' + key).css({'top': value['top'], 'left': value['left'], 'bottom': value['bottom']})
        }

		if(this.mode == 'bigmap') {
			this.currentSize = defaultSize * (this.position.width / bigAlign.width);
		} else {
			this.currentSize = defaultSize * (this.position.width / defaultAlign.width);
		}

		$('.map #belt').css('width', this.currentSize);
		$('.map #belt').css('height', this.currentSize);

		$('.map').css('fontSize', this.currentSize);
		switch(this.mode) {
			case 'minimap':
				$('.map').show();
				$('#compass-round').show();
				break;
			case 'bigmap':
				$('.map').addClass('big');
				$('.map').show();
				$('#compass-flat').show();
				break;
			default:
				break;
		}
    }

    settings() {
		$(".options").css("opacity", "1.00");
		$.post('https://Radar/focus', JSON.stringify({status: true}));
    }

	lerp(min, max, amt) {
		return (1 - amt) * min + amt * max;
	}

	rangePercent(min, max, amt) {
		return (((amt - min) * 100) / (max - min)) / 100;
	}

	axon(data) {
		if(data && data.display) {
			$('.axon').show();
			if(this.axonTimer !== null) {
				clearInterval(this.axonTimer);
				this.axonTimer = null;
			}

			this.axonTimer = setInterval(this.axonTick, 1000);
			$('#axon-name').html(data.display);
			$('#axon-badge').html(data.badge);
		} else {
			$('.axon').hide();
			if(this.axonTimer !== null) {
				clearInterval(this.axonTimer);
				this.axonTimer = null;
			}
		}
	}

	axonTick() {
		var d = new Date();
		var h = d.getHours();
		var m = d.getMinutes();
		var s = d.getSeconds();

		var day = d.getDate();
		var month = d.getMonth();
		var year = d.getFullYear();

		var t = d.toLocaleString('en', {
			timeZoneName: 'short'
		}).split(' ').pop();

		s++;
		if(s == 60) {
			s = 0;
		}

		m++;
		if(m == 60) {
			m = 0;
		}

		h++;
		if(h == 24) {
			h = 0;
		}

		$('#axon-t').html(String(t));
		$('#axon-s').html(String(s).padStart(2, '0'));
		$('#axon-m').html(String(m).padStart(2, '0'));
		$('#axon-h').html(String(h).padStart(2, '0'));

		$('#axon-d').html(String(day).padStart(2, '0'));
		$('#axon-mo').html(monthNames[month]);
		$('#axon-y').html(String(year).padStart(2, '0'));
	}

	update(data) {
		var voiceVehicle = null;
		var voicePress = null;

		for(var key in data) {
			var value = data[key];
			switch(key) {
				case 'Health':
					value = parseFloat(parseFloat((value - 100) / 100).toFixed(2));
					this.health.animate(value);
					this.warn('health', value);
					break;
				case 'Armor':
					value = parseFloat(parseFloat(value / 100).toFixed(2));
					this.armor.animate(value);
					break;
				case 'Stamina':
					value = parseFloat(parseFloat((100 - Math.min(100, value)) / 100).toFixed(2));
					this.stamina.animate(value);
					this.warn('stamina', value);
					break;
				case 'Oxygen':
					value = parseFloat(parseFloat(value / 10).toFixed(2));
					this.oxygen.animate(value);
					this.warn('oxygen', value);
					break;
				case 'Rotation':
					if(this.mode == 'minimap') {
						if($('#compass-round').is(':visible')) {
							$('#compass-round').stop();
							$('#compass-round').css('transform', 'rotate(' + parseFloat(value).toFixed(2) + 'deg)');
						}
					} else if(this.mode == 'bigmap') {
						if($('#compass-flat').is(':visible')) {
							var width = parseFloat($('#compass-flat').css('width'));
							var direction = -value % 360;

							var positions = {
								south: -width,
								west: -width * 2,
								north: -width * 3,
								east: -width * 4,
								_south: -width * 5
							};

							var result = NaN;
							if (direction < 90) {
								result = this.lerp(positions.north, positions.east, direction / 90);
							} else if (direction < 180) {
								result = this.lerp(positions.east, positions._south, this.rangePercent(90, 180, direction));
							} else if (direction < 270) {
								result = this.lerp(positions.south, positions.west, this.rangePercent(180, 270, direction));
							} else if (direction <= 360) {
								result = this.lerp(positions.west, positions.north, this.rangePercent(270, 360, direction));
							}

							if (!isNaN(result)) {
								$('#compass-flat div').stop();
								$('#compass-flat div').css('transform', 'translate3d(' + result + 'px, 0px, 0px)');
							}
						}
					}
					break;
				case 'GpsDistance':
					if(this.inVehicle && value > 0) {
						$('#distance').html(parseFloat(value / 1000).toFixed(2) + 'km');
					} else {
						$('#distance').html('');
					}
					break;
				case 'GpsDirection':
					if(!this.inVehicle || value == 0) {
						$('#direction img').attr('src', 'img/gps_0.png');
					} else if($('#direction img').length > 0) {
						$('#direction img').attr('src', 'img/gps_' + value + '.png');
					}
					break;
				case 'Direction':
					$('#compass').html('<u>' + value + '</u>');
					break;
				case 'Zone':
					$('#zone').html('<b>' + value + '</b>');
					break;
				case 'Street':
					if(value.length > 1) {
						$('#street').html(value[0] + ' <i>' + value[1] + '</i>');
					} else {
						$('#street').html(value[0]);
					}
					break;
				case 'Clock':
					$('#clock').html(value);
					break;
				case 'Vehicle':
					if(value && value > 0) {
						this.inVehicle = true;
						if(this.seatBelt != $('#belt').hasClass('active')) {
							$('#belt').toggleClass('active');
						}

						if($('#belt').is(':hidden')) {
							$('#belt').show();
						}
					} else {
						this.inVehicle = false;
						this.disableVehicle();
					}
					break;
				case 'Gear':
					if(this.inVehicle) {
						if(!isNaN(parseFloat(value))) {
							$('#gear').html('/' + value);
						} else {
							$('#gear').html('/<s>' + value + '</s>');
						}
					}
					break;
				case 'CruiseControl':
					if(!this.inVehicle) {
						//
					} else if(value) {
						if(!this.cruiseControlled) {
							$('#speed').addClass('cruise');
							this.cruiseControlled = true;
						}
					} else if(this.cruiseControlled) {
						$('#speed').removeClass('cruise');
						this.cruiseControlled = false;
					}
					break;
				case 'Speed':
					if(this.inVehicle) {
						if(value > 160) {
							$('#speed').html(value + ' <u>KPH</u>');
						} else if(value > 80) {
							$('#speed').html(value + ' <s>KPH</s>');
						} else {
							$('#speed').html(value + ' KPH');
						}
					}
					break;
				case 'RPM':
					if(this.inVehicle) {
						if(this.rpmScale === -1) {
							$('#rpm').html(value + ' mnpm');
						} else if(this.rpmScale !== 0) {
							$('#rpm').html(value + ' rpm');
							if(value >= this.rpmScale) {
								$('#rpm').addClass('high');
							} else {
								$('#rpm').removeClass('high');
							}
						}
					}
					break;
				case 'RPMScale':
					if(value > 1000) {
						value -= 1000;
					}
					this.rpmScale = value;
					break;
				case 'Hunger':
					value = parseFloat(parseFloat(value / 100).toFixed(2));
					this.hunger.animate(value);
					this.warn('hunger', value);
					break;
				case 'Water':
					value = parseFloat(parseFloat(value / 100).toFixed(2));
					this.thirst.animate(value);
					this.warn('thirst', value);
					break;
				case 'Drunk':
					value = parseFloat(parseFloat(value / 100).toFixed(2));
					this.drunk.animate(value);
					break;
				case 'VoiceStrength':
					switch(value) {
						case 0:
							this.voice.animate(0.1);
							voiceVehicle = false;
							break;
						case 1:
							this.voice.animate(0.33);
							voiceVehicle = true;
							break;
						case 2:
							this.voice.animate(0.5);
							voiceVehicle = false;
							break;
						case 3:
							this.voice.animate(1.0);
							voiceVehicle = false;
							break;
						default:
							break;
					}

					this.lastVoiceVehicle = voiceVehicle;
					if(voicePress === null) {
						voicePress = this.lastVoicePress;
					}
					break;
				case 'VoiceTalk':
					if (value) {
						$('#voice').css({'animation': 'pulse-blue 2s infinite'});
					} else {
						$('#voice').css({'animation': ''});
					}
					break;
				case 'VoicePress':
					voicePress = value;
					if(voiceVehicle === null) {
						voiceVehicle = this.lastVoiceVehicle;
					}
					break;
				case 'Belt':
					if($('#belt').is(':visible')) {
						if($('#belt').hasClass('active') != value) {
							$('#belt').toggleClass('active');
						}
					}

					this.seatBelt = value;
					break;
				case 'Radio':
					if (value) {
						$('.radio').show();
					} else {
						$('.radio').hide();
						$('.radio > p > b').html('');
						$('.radio > p > u').html('');
						$('.radio > span').html('X');
					}
					break;
				case 'Camera':
					if (value) {
						$('.camera').show();
					} else {
						$('.camera').hide();
					}
					break;
				case 'Gps':
					if (value) {
						$('.gps').show();
					} else {
						$('.gps').hide();
					}
					break;
				case 'TokoChannel':
					if (value != -1) {
						$('.radio > p > b').html(value);
					} else {
						$('.radio > p > b').html('');
					}
					break;
				case 'TokoUsers':
					if (value != -1) {
						$('.radio > p > u').html('(' + value + ')');
					} else {
						$('.radio > p > u').html('');
					}
					break;
				case 'TokoMode':
					if (value != -1) {
						$('.radio > span').html(value === 0 ? 'T' : (value === 4 ? 'S' : 'C'));
					} else {
						$('.radio > span').html('X');
					}
					break;
				case 'TokoTalk':
					if (value) {
						$('.radio img').addClass('heartbeat');
					} else {
						$('.radio img').removeClass('heartbeat');
					}
				default: break;
			}
		}

		var update = true;
		if(voiceVehicle === true && voicePress === true) {
			$('#voice_img').attr('src', 'img/voice_press.png');
		} else if(voiceVehicle === true && voicePress === false) {
			$('#voice_img').attr('src', 'img/voice_normal.png');
		} else if(voiceVehicle === false && voicePress === true) {
			$('#voice_img').attr('src', 'img/voice_press.png');
		} else if(voiceVehicle === false && voicePress === false) {
			$('#voice_img').attr('src', 'img/voice_normal.png');
		} else {
			update = false;
		}

		if(update) {
			this.lastVoiceVehicle = voiceVehicle || false;
			this.lastVoicePress = voicePress || false;
		}
	}
}

var init = false;
$(function() {
    var data = window.localStorage.getItem('WRP_ui');
    if (data) {
		try {
			app = new UI(JSON.parse(data));
		} catch(e) {
			console.log("Could not parse saved preferences, resetting data!");
			app = new UI();
			init = true;
		}
    } else {
		app = new UI();
		init = true;
	}

	app.init();
})

window.addEventListener('message', function(event) {
    var data = event.data
	if (data.ticket && app) {
		app.keepTicket = true;
	}

    switch (data.type) {
		case 'init':
			$('.container').show();
			if(init) {
                $.post('https://Radar/focus', JSON.stringify({status: true}));
				$(".options").css("opacity", "1.00");
			}

			$(".ticket b").html(data.value);
			$(".ticket").css("opacity", "1.00");
			$.post('https://Radar/ready', JSON.stringify());
		case 'show':
			if (app) {
				app.show();
			}
			break;
		case 'hide':
			if (app) {
				app.hide();
			}
			break;
		case 'axon':
			if (app) {
				app.axon(data.data);
			}
			break;
		case 'inventory':
			if (app) {
				app.inventory(data.add, data.item, data.count)
			}
			break;
		case 'description':
			if (app) {
				app.description(data.label, data.name, data.description);
			}
			break;
		case 'wheel':
			if (app) {
				if (data.data) {
					app.wheel(data.data);
				} else {
					app.disableWheel();
				}
			}
			break;
        case 'options':
			if (app) {
				app.settings();
			}
            break;
        case 'update':
			if (app) {
				if(data.data) {
					app.update(data.data);
				}
				if(data.anchor) {
					app.align(data.anchor);
				}
			}
            break;
		case 'rebuild':
			if (app) {
				app.rebuild(data.value);
			}
			break;
        default:
            break;
    }
});