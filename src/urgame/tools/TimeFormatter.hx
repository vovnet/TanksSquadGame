package urgame.tools;

/**
 * ...
 * @author Vladimir
 */
class TimeFormatter {

	public function new() {
		
	}
	
	public static function minutesFormat(input:Int):String {
		var hrs:String = (input > 3600 ? Math.floor(input / 3600) + ':' : '');
		var mins:String = (hrs != "" && input % 3600 < 600 ? '0' : '') + Math.floor(input % 3600 / 60) + ':';
		var secs:String = (input % 60 < 10 ? '0' : '') + input % 60;
		return mins + secs;
	}
	
}