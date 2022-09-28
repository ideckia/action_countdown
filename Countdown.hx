package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Initial time for the countdown. The unit is definde with the value (s or m). If no unit is provided, default is seconds. Examples: 3s, 15m.",
		"25m")
	var initial_time:String;
	@:editable("Add this time to the countdown when longpress the button when running the timer.", '5m')
	var add_time:String;
	@:editable("Sound to play when countdown is over.")
	var sound_path:String;
}

@:name("countdown")
@:description("Countdown timer")
class Countdown extends IdeckiaAction {
	var timeEreg = ~/([0-9]+)[\s]*(s|m)?/;
	var timer:haxe.Timer;
	var initialSeconds:UInt;
	var time:datetime.DateTime;
	var isRunning:Bool;
	var soundPath:String;

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			isRunning = false;
			soundPath = if (props.sound_path == null) {
				haxe.io.Path.join([js.Node.__dirname, 'alarm.wav']);
			} else {
				props.sound_path;
			}
			calculateSeconds(props.initial_time).then(seconds -> {
				time = new datetime.DateTime(0).add(Second(Std.int(seconds)));
				initialState.text = time.format('%M:%S');
				initialSeconds = seconds;

				resolve(initialState);
			});
		});
	}

	public function execute(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			if (time == null) {
				reject('The given time value ${props.initial_time} is not a valid value.');
				return;
			}

			if (timer == null) {
				timer = new haxe.Timer(1000);
				timer.run = () -> {
					if (!isRunning)
						return;
					time = time.add(Second(-1));
					server.updateClientState({
						text: time.format('%M:%S')
					});

					if (time.getTime() <= 0) {
						var initialDt = new datetime.DateTime(0).add(Second(Std.int(initialSeconds)));
						currentState.text = initialDt.format('%M:%S');
						server.mediaPlayer.play(soundPath);
						resolve(currentState);
						timer.stop();
					}
				};
			}

			isRunning = !isRunning;
		});
	}

	override public function onLongPress(currentState:ItemState):js.lib.Promise<ItemState> {
		if (isRunning) {
			calculateSeconds(props.add_time).then(seconds -> {
				time = time.add(Second(seconds));
			});
		} else {
			time = new datetime.DateTime(0).add(Second(Std.int(initialSeconds)));
			currentState.text = time.format('%M:%S');
		}
		return super.onLongPress(currentState);
	}

	function calculateSeconds(timeString):js.lib.Promise<UInt> {
		return new js.lib.Promise((resolve, reject) -> {
			if (timeString == null || Std.parseInt(timeString) == null || !timeEreg.match(timeString)) {
				server.dialog.error('Wait error', 'The given time value $timeString is not a valid value.');
			} else {
				var timeValue = Std.parseInt(timeEreg.matched(1));
				var timeUnit:TimeUnit = timeEreg.matched(2);
				resolve(timeUnit.toSeconds(timeValue));
			}
		});
	}
}

enum TimeUnitEnum {
	s;
	m;
}

abstract TimeUnit(TimeUnitEnum) from TimeUnitEnum {
	inline function new(tu:TimeUnitEnum)
		this = tu;

	public function toSeconds(timeValue:UInt)
		return switch this {
			case TimeUnitEnum.s: timeValue;
			case TimeUnitEnum.m: timeValue * 60;
		}

	@:from
	static public inline function fromString(s:String) {
		return new TimeUnit(switch s {
			case 's':
				TimeUnitEnum.s;
			case 'm':
				TimeUnitEnum.m;
			case x:
				trace('Unknown time unit [$x]. Using seconds by default.');
				TimeUnitEnum.s;
		});
	}
}
