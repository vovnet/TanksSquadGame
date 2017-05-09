package urgame.units.skills;

import flambe.Component;
import flambe.Entity;
import flambe.swf.MovieSprite;
import flambe.util.Pool;
import urgame.data.TankData;
import urgame.effects.EffectsFactory;
import urgame.screens.GameScreen;
import urgame.units.heroes.HeroAI;

/**
 * ...
 * @author Vladimir
 */
class RepairSkill extends Component {
	public static inline var WORK_TIME:Float = 5;
	public static inline var REPAIR_RATE:Float = 0.08;
	
	private var unit:HeroAI;
	private var data:TankData;
	private var delay:Float = 0;
	private var movie:MovieSprite;
	private var game:GameScreen;
	
	public function new() {
		
	}
	
	public function init(data:TankData, unit:HeroAI, game:GameScreen) {
		this.data = data;
		this.unit = unit;
		this.game = game;
		delay = 0;
	}
	
	override public function onStart() {
		super.onStart();
		movie = owner.get(MovieSprite);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		data.currentHealth += data.health * REPAIR_RATE * dt;
		if (data.currentHealth > data.health) data.currentHealth = data.health;
		
		delay += dt;
		if (delay >= WORK_TIME || unit.state == HeroAI.REPAIR_STAY) {
			delay = 0;
			owner.parent.removeChild(owner);
			game.poolRepairSkill.put(owner);
		}
	}
	
	
	
}