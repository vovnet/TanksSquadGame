package urgame.units.skills;

import flambe.Component;
import urgame.screens.GameScreen;
import urgame.units.heroes.HeroAI;

/**
 * ...
 * @author Vladimir
 */
class FieldSkill extends Component {
	private static inline var WORKING_TIME:Float = 5;
	
	private var unit:HeroAI;
	private var game:GameScreen;
	private var delay:Float;

	public function new() {
		
	}
	
	public function init(unit:HeroAI, game:GameScreen) {
		this.unit = unit;
		this.game = game;
		delay = 0;
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		delay += dt;
		if (delay >= WORKING_TIME) {
			delay = 0;
			owner.parent.removeChild(owner);
			game.poolFieldSkill.put(owner);
			unit.isProtected = false;
		} else {
			unit.isProtected = true;
		}
	}
	
}