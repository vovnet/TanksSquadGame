package urgame.effects;

import flambe.Component;
import flambe.Entity;
import flambe.display.TextSprite;
import flambe.util.Pool;

/**
 * ...
 * @author Vladimir
 */
class EffectField extends Component {
	private var pool:Pool<Entity>;
	private var endValue:Float;

	public function new() {
		
	}
	
	override public function onAdded() {
		super.onAdded();
		var spr:TextSprite = owner.get(TextSprite);
		spr.y.changed.connect(onChanged);
	}
	
	public function init(pool:Pool<Entity>) {
		this.pool = pool;
		var spr:TextSprite = owner.get(TextSprite);
		endValue = spr.y._ - 60;
		spr.y.animateTo(endValue, 0.6);
	}
	
	function onChanged(current:Float, old:Float) {
		if (current == endValue) {
			owner.parent.removeChild(owner);
			pool.put(owner);
		}
	}
	
}