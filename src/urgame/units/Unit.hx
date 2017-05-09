package urgame.units;
import flambe.Component;
import flambe.Entity;
import flambe.animation.AnimatedFloat;
import flambe.util.Signal1;

/**
 * @author Vladimir
 */

class Unit extends Component {
	public var eventKill:Signal1<Entity> = new Signal1<Entity>();
	public var percentHealth:AnimatedFloat = new AnimatedFloat(0);
	
	public function new() {
		
	}
	
	public function setDamage(damage:Float, isCrit:Bool):Void {
		
	}
	
	public function kill():Void {
		eventKill.emit(owner);
	}
	
	public function fire(damage:Float):Bool {
		return false;
	}
}