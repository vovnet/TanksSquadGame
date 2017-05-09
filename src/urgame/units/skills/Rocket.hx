package urgame.units.skills;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import urgame.screens.GameScreen;
import urgame.units.Unit;

/**
 * ...
 * @author Vladimir
 */
class Rocket extends Component {
	private var skill:RocketSkill;
	private var game:GameScreen;
	private var sprite:ImageSprite;
	private var endX:Float;
	private var endY:Float;
	private var speed:Float = 600;

	public function new(skill:RocketSkill, game:GameScreen) {
		this.skill = skill;
		this.game = game;
	}
	
	override public function onStart() {
		super.onAdded();
		
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		sprite.x._ += speed * dt;
		sprite.y._ += speed * dt;
		if (sprite.x._ >= endX || sprite.y._ >= endY) {
			owner.parent.removeChild(owner);
			skill.poolRockets.put(owner);
			damage();
			var exp:Entity = skill.poolExplotions.take();
			var expComp:PoolableAnimation = exp.get(PoolableAnimation);
			expComp.init(sprite.x._, sprite.y._);
			game.rocketLayer.addChild(exp);
			G.pack.getSound("sounds/explosion").play();
		}
	}
	
	function damage() {
		var unit:Unit;
		for (i in game.enemies) {
			unit = i.get(Unit);
			unit.setDamage(G.gameData.bossDamage / 10, false);
		}
	}
	
	public function init(endX:Float, endY:Float) {
		this.endX = endX;
		this.endY = endY;
		sprite = owner.get(ImageSprite);
		var startX:Float = endX / 2;
		var startY:Float = -90; 
		sprite.setXY(startX, startY);
		sprite.setRotation(45);
		G.pack.getSound("sounds/rocket_fall").play();
	}
	
}