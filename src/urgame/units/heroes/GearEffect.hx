package urgame.units.heroes;

import flambe.Component;
import flambe.swf.MovieSprite;

/**
 * ...
 * @author Vladimir
 */
class GearEffect extends Component {
	private var unit:HeroAI;
	private var movie:MovieSprite;

	public function new(unit:HeroAI) {
		this.unit = unit;
	}
	
	override public function onAdded() {
		super.onAdded();
		movie = owner.get(MovieSprite);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (unit.state == HeroAI.REPAIR_STAY) {
			owner.add(movie);
		} else {
			owner.remove(movie);
		}
	}
	
}