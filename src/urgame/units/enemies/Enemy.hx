package urgame.units.enemies;

import flambe.Component;
import flambe.Entity;
import flambe.display.Sprite;
import urgame.gui.ProgressBar;
import urgame.screens.GameScreen;
import urgame.tools.BigNumber;
import urgame.units.Unit;
import urgame.weapons.Gun;

/**
 * ...
 * @author Vladimir
 */
class Enemy extends Unit {
	public var health:Float;
	public var positions:EnemyPositions;
	public var isBoss:Bool = false;
	
	private var game:GameScreen;
	private var goal:Unit;
	private var entityGoal:Entity;
	var bar:ProgressBar;
	var startHealth:Float;
	private var weapons:Array<Entity>;
	
	public function new(weapons:Array<Entity>) {
		super();
		this.weapons = weapons;
	}
	
	public function init(health:Float, maxDamage:Float, game:GameScreen, positions:EnemyPositions):Enemy {
		startHealth = health;
		this.health = health;
		this.game = game;
		this.positions = positions;
		var gun:Gun;
		for (i in weapons) {
			gun = i.get(Gun);
			gun.init(maxDamage);
		}
		return this;
	}
	
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		percentHealth._ = health / startHealth;
	}
	
	override public function fire(damage:Float):Bool {
		super.fire(damage);
		entityGoal = Random.fromArray(game.heroes);
		if (entityGoal != null) {
			goal = entityGoal.get(Unit);
			if (goal != null) {
				goal.setDamage(damage, false);
				return true;
			}
		}
		return false;
	}
	
	override public function setDamage(damage:Float, isCrit:Bool):Void {
		health -= damage;
		var sprite:Sprite = owner.get(Sprite);
		var x:Float = Random.float(sprite.x._ - sprite.getNaturalWidth(), sprite.x._ );
		var y:Float = Random.float(sprite.y._ - 20, sprite.y._ + 20);
		if (damage < 1000) {
			damage = Math.fround(damage);
		}
		if (isCrit) {
			game.textEffects.showCrit(BigNumber.format(damage), x, y);
		} else {
			game.textEffects.showDamage(BigNumber.format(damage), x, y);
		}
		if (health <= 0) {
			G.gameData.tanksKillKong++;
			game.enemies.remove(owner);
			var unit:Unit = owner.get(Unit);
			unit.kill();
			if (isBoss) {
				game.showBigScrap(sprite.x._ - 330, sprite.y._ + 80);
				game.showBigExplostion(sprite.x._ - 430, sprite.y._ - 100);
			} else {
				game.showSmallScrap(sprite.x._ - 140, sprite.y._ + 32);
				game.showSmallExplosion(sprite.x._ - 200, sprite.y._ - 50);
			}
			
			
			var award:Float = G.gameData.bossHealth / 50;
			G.gameData.money += award;
			game.textEffects.showCoin("+" + BigNumber.format(award), sprite.x._ - sprite.getNaturalWidth() / 2, sprite.y._ - sprite.getNaturalHeight() / 2);
		}
	}
	
}