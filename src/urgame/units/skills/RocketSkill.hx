package urgame.units.skills;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import flambe.util.Pool;
import urgame.effects.EffectsFactory;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class RocketSkill extends Component {
	private static inline var ROCKET_DELAY:Float = 0.5;
	private static inline var WORK_TIME:Float = 15;
	
	public var poolRockets:Pool<Entity>;
	public var poolExplotions:Pool<Entity>;
	
	private var workDelay:Float = 0;
	private var nextRocketTime:Float = 0;
	private var game:GameScreen;

	public function new(game:GameScreen) {
		this.game = game;
		poolRockets = new Pool<Entity>(fillRocketPool).setSize(20);
		poolExplotions = new Pool<Entity>(fillExplotionPool).setSize(20);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		workDelay += dt;
		if (workDelay >= WORK_TIME) {
			owner.remove(this);
			workDelay = 0;
			nextRocketTime = 0;
		} else {
			if (workDelay >= nextRocketTime) {
				nextRocketTime += ROCKET_DELAY;
				var rocketEnt:Entity = poolRockets.take();
				var rocket:Rocket = rocketEnt.get(Rocket);
				rocket.init(Random.int(500, 1100), Random.int(120, 420));
				game.rocketLayer.addChild(rocketEnt);
			}
		}
	}
	
	private function fillRocketPool():Entity {
		return new Entity()
			.add(new Rocket(this, game))
			.add(new ImageSprite(G.pack.getTexture("weapons/rocket")).disablePointer());
	}
	
	private function fillExplotionPool():Entity {
		return new Entity()
			.add(EffectsFactory.createEffect("explosion").disablePointer())
			.add(new PoolableAnimation(poolExplotions));
	}
	
}