package urgame.effects;

import flambe.Component;
import flambe.swf.MovieSprite;

/**
 * ...
 * @author Vladimir
 */
class BigExplosion extends Component {
	private var movie:MovieSprite;

	public function new() {
		movie = EffectsFactory.createEffect("big_explosion");
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.add(movie);
		movie.centerAnchor();
		
		movie.looped.connect(onComplete);
	}
	
	function onComplete() {
		owner.parent.removeChild(owner);
	}
	
}