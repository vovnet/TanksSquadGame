package urgame.effects;

import flambe.Component;
import flambe.Entity;
import flambe.animation.Ease;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Pool;

/**
 * ...
 * @author Vladimir
 */
class EffectCrit extends Component {
	private var pool:Pool<Entity>;
	private var endValue:Float;
	private var script:Script;
	private var sequence:Sequence;

	public function new() {
	}
	
	override public function onAdded() {
		super.onAdded();
		script = new Script();
		sequence = new Sequence([new Delay(1), new CallFunction(complete)]);
		owner.add(script);
	}
	
	public function init(pool:Pool<Entity>) {
		this.pool = pool;
		var spr:Sprite = owner.get(Sprite);
		spr.scaleX.animate(0, 1, 0.3, Ease.backInOut);
		spr.scaleY.animate(0, 1, 0.3, Ease.backInOut);
		script.run(sequence);
	}
	
	function complete() {
		owner.parent.removeChild(owner);
		pool.put(owner);
	}
	
}