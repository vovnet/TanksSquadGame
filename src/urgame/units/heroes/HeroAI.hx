package urgame.units.heroes;

import flambe.Component;
import flambe.Entity;
import flambe.display.Graphics;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.swf.MovieSprite;
import urgame.data.TankData;
import urgame.gui.ProgressBar;
import urgame.screens.GameScreen;
import urgame.tools.BigNumber;
import urgame.units.Unit;

/**
 * ...
 * @author Vladimir
 */
class HeroAI extends Unit {
	public var fireAnimation:MovieSprite;
	
	public static inline var PLAY_STAY:String = "play";
	public static inline var REPAIR_STAY:String = "repair";
	public var state:String = PLAY_STAY;
	
	public var isProtected:Bool = false;
	
	private var game:GameScreen;
	private var visual:Sprite;
	private var repairDelay:Float;
	private var repairTime:Float = 15;

	public function new(game:GameScreen, visual:Sprite) {
		super();
		this.game = game;
		this.visual = visual;
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		switch (state) {
			case PLAY_STAY:
				var data:Data = owner.get(Data);
				percentHealth._ = data.getCurrentHealth() / data.getSumHealth();
			case REPAIR_STAY:	
				repairDelay += dt;
				percentHealth._ = repairDelay / repairTime;
				if (repairDelay >= repairTime) {
					state = PLAY_STAY;
					visual.setAlpha(1);
					game.heroes.push(owner);
					var data:Data = owner.get(Data);
					data.init();
				}
		}
		
	}
	
	override function fire(damage:Float):Bool {
		if (state == REPAIR_STAY) return false;
		
		super.fire(damage);
		var goal:Entity = Random.fromArray(game.enemies);
		if (goal != null) {
			G.pack.getSound("sounds/shoot").play();
			var unit:Unit = goal.get(Unit);
			var data = owner.get(Data);
			damage = data.getDamage();
			var isCrit:Bool = Random.bool();
			if (isCrit) {
				damage = data.getCrit();
			}
			unit.setDamage(damage, isCrit);
			return true;
		}
		return false;
	}
	
	override function setDamage(damage:Float, isCrit:Bool):Void {
		if (isProtected) return;
		
		var data:Data = owner.get(Data);
		data.hurt(damage);
		percentHealth._ = data.getCurrentHealth() / data.getSumHealth();
		if (data.getCurrentHealth() <= 0) {
			game.heroes.remove(owner);
			state = REPAIR_STAY;
			visual.setAlpha(0.5);
			repairDelay = 0;
		}
		var data:Data = owner.get(Data);
		
		if (damage < 1) damage = 1;
		game.textEffects.showDamage(BigNumber.format(damage), Random.float(data.data.x - 50, data.data.x + 50), Random.float(data.data.y - 150, data.data.y - 200));
	}
	
}