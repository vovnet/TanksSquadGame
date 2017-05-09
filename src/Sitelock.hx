package;
import js.Browser;

/**
 * ...
 * @author Vladimir
 */
class Sitelock {
	static public var sites = [
		"v91838lm.beget.tech"
	];

	public function new() {
		
	}
	
	/**
	 * 
	 * @return true if all OK.
	 */
	static public function checkSitelock():Bool {
		for (i in sites) {
			if (i == Browser.location.hostname) {
				return true;
			}
		}
		return false;
	}
	
}