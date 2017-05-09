package urgame.units.skills;

import flambe.Component;
import flambe.Entity;
import flambe.swf.MovieSprite;
import flambe.util.Pool;

/**
 * ...
 * @author Vladimir
 */
class PoolableAnimation extends Component {
	private var pool:Pool<Entity>;
	private var movie:MovieSprite;
	private var x:Float;
	private var y:Float;

	public function new(pool:Pool<Entity>) {
		this.pool = pool;
	}
	
	public function init(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		movie.setXY(x, y);
	}
	
	override public function onAdded() {
		super.onAdded();
		movie = owner.get(MovieSprite);
		movie.looped.connect(onEndAnimation);
	}
	
	function onEndAnimation() {
		if (pool != null ) pool.put(owner);
		owner.parent.removeChild(owner);
	}
	
}