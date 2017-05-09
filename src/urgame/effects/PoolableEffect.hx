package urgame.effects;

import flambe.Component;
import flambe.Entity;
import flambe.swf.MovieSprite;
import flambe.util.Pool;

/**
 * ...
 * @author Vladimir
 */
class PoolableEffect extends Component {
	private var pool:Pool<Entity>;
	var movie:MovieSprite;

	public function new() {
		
	}
	
	override public function onStart() {
		super.onStart();
		movie = owner.get(MovieSprite);
		movie.looped.connect(onComplete);
	}
	
	public function init(pool:Pool<Entity>) {
		this.pool = pool;
		if (movie != null) {
			movie.position = 0;
		}
	}
	
	function onComplete() {
		owner.parent.removeChild(owner);
		pool.put(owner);
	}
	
	
}