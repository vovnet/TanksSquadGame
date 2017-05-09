package urgame.tools;

/**
 * ...
 * @author Vladimir
 */
class BigNumber {
	private static var bigNum:String;
	private static var aK:Float = 1000;
	private static var aM:Float = 1000000;
	private static var aB:Float = 1000000000;
	private static var aT:Float = 1000000000000;
	private static var aQ:Float = 1000000000000000;
	private static var aC:Float = 1000000000000000000;
	private static var aF:Float = 1000000000000000000000;

	public function new() {
		
	}

	public static function format(number:Float):String {
		if (number < 1000) number = Math.ffloor(number);
		
		if (number >= aK && number < aM) {
			bigNum = substr(number / aK);
			return bigNum + "k";
		} else if (number >= aM && number < aB) {
			bigNum = substr(number / aM);
			return bigNum + "m";
		} else if (number >= aB && number < aT) {
			bigNum = substr(number / aB);
			return bigNum + "b";
		} else if (number >= aT && number < aQ) {
			bigNum = substr(number / aT);
			return bigNum + "t";
		} else if (number >= aQ && number < aC) {
			bigNum = substr(number / aQ);
			return bigNum + "q";
		} else if (number >= aC && number < aF) {
			bigNum = substr(number / aC);
			return bigNum + "c";
		} else if (number >= aF) {
			bigNum = substr(number / aF);
			return bigNum + "f";
		} else {
			bigNum = substr(number);
			return bigNum;
		}
	}
	
	private static function substr(num:Float):String {
		var s:String = Std.string(num);
		var i:Int = s.indexOf('.');
		if (s.indexOf(".0") > -1) {
			return s.substr(0, i);
		}
		
		if (i > 0) {
			return s.substr(0, i + 2);
		}
		return s;
	}
	
}