package urgame.units.enemies;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.swf.MovieSprite;
import format.tools.Image;
import urgame.gui.ProgressBar;
import urgame.weapons.Gun;
import urgame.weapons.WeaponsFactory;

/**
 * ...
 * @author Vladimir
 */
class EnemiesFactory {

	public function new() {
		
	}
	
	static public function createEnemy(id:Int):Entity {
		var enemy:Entity = new Entity();
		var sprite:ImageSprite = getSprite("tanks/tank_" + id);
		sprite.scaleX._ = -1;
		var weapons:Array<Entity> = getWeapons(id);
		var en:Enemy = new Enemy(weapons);
		
		var backBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/bars/hp_4"));
		var fillBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/bars/hp_3"));
		
		var enemy:Entity = new Entity()
			.add(sprite)
			.add(new ProgressBar(backBar, fillBar, sprite.getNaturalWidth() / 2, sprite.getNaturalHeight(), en.percentHealth))
			.add(en)
			.add(new ClickHurt());
			
		// add weapons
		for (i in weapons) {
			enemy.addChild(i);
		}
		return enemy;
	}
	
	static public function createBoss(id:Int):Entity {
		var sprite:ImageSprite = getSprite("tanks/boss_" + id);
		sprite.scaleX._ = -1;
		
		var weapons:Array<Entity> = getBossWeapons(id);
		var en:Enemy = new Enemy(weapons);
		en.isBoss = true;
		
		var backBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/boss/hp_back"));
		var fillBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/boss/hp_front"));
		var bar:Entity = new Entity().add(new ProgressBar(backBar, fillBar, sprite.getNaturalWidth() / 2, sprite.getNaturalHeight(), en.percentHealth));
		
		var boss:Entity = new Entity()
			.add(sprite)
			.addChild(bar)
			.add(en)
			.add(new ClickHurt());
			
		// add weapons
		for (i in weapons) {
			boss.addChild(i);
		}
		return boss;
	}
	
	static private function getSprite(name:String):ImageSprite {
		return new ImageSprite(G.pack.getTexture(name));
	}
	
	static private function getBossWeapons(id:Int):Array<Entity> {
		var spr:MovieSprite;
		var weapons:Array<Entity> = new Array<Entity>();
		var gunSound:String = "sounds/shoot";
		var mashinegunSound:String = "sounds/shoot_mashinegun";
		switch (id) {
			case 1:
				weapons.push(WeaponsFactory.createGun(2, 20, 130, -8, "gun", gunSound));
				
				var leftGun:Entity = WeaponsFactory.createGun(1.6, 10, 250, 62, "gun", gunSound);
				spr = leftGun.get(MovieSprite);
				spr.rotation._ = -30;
				spr.setScale(0.6);
				weapons.push(leftGun);
				
				var rightGun:Entity = WeaponsFactory.createGun(1.6, 10, 190, 62, "gun", gunSound);
				spr = rightGun.get(MovieSprite);
				spr.rotation._ = -30;
				spr.setScale(0.6);
				weapons.push(rightGun);
				
				var machGun:Entity = WeaponsFactory.createGun(1, 10, 94, -10, "machineGun", mashinegunSound);
				spr = machGun.get(MovieSprite);
				spr.speed._ = 5;
				weapons.push(machGun);
			case 2:
				var bigGun:Entity = WeaponsFactory.createGun(2.8, 25, 130, -18, "gun", gunSound);
				spr = bigGun.get(MovieSprite);
				spr.rotation._ = -30;
				spr.setScale(1.5);
				weapons.push(bigGun);
				
				var smallGun:Entity = WeaponsFactory.createGun(1.6, 12, 120, 70, "gun", gunSound);
				spr = smallGun.get(MovieSprite);
				spr.setScale(0.6);
				weapons.push(smallGun);
				
				var leftGun:Entity = WeaponsFactory.createGun(1.8, 12, 230, 50, "gun", gunSound);
				spr = leftGun.get(MovieSprite);
				spr.rotation._ = -30;
				spr.setScale(0.6);
				weapons.push(leftGun);
				
				var rightGun:Entity = WeaponsFactory.createGun(1.8, 12, 200, 50, "gun", gunSound);
				spr = rightGun.get(MovieSprite);
				spr.rotation._ = -30;
				spr.setScale(0.6);
				weapons.push(rightGun);
			case 3:
				var leftGun:Entity = WeaponsFactory.createGun(1.6, 18, 200, 0, "gun", gunSound);
				spr = leftGun.get(MovieSprite);
				spr.rotation._ = -30;
				weapons.push(leftGun);
				
				var centerGun:Entity = WeaponsFactory.createGun(1.6, 18, 170, 0, "gun", gunSound);
				spr = centerGun.get(MovieSprite);
				spr.rotation._ = -30;
				weapons.push(centerGun);
				
				var rightGun:Entity = WeaponsFactory.createGun(1.6, 18, 140, 0, "gun", gunSound);
				spr = rightGun.get(MovieSprite);
				spr.rotation._ = -30;
				weapons.push(rightGun);
			case 4:
				var upGun:Entity = WeaponsFactory.createGun(1.4, 15, 160, -10, "gun", gunSound);
				spr = upGun.get(MovieSprite);
				spr.setScale(0.5);
				weapons.push(upGun);
				
				var leftGun:Entity = WeaponsFactory.createGun(2.4, 15, 260, -30, "gun", gunSound);
				spr = leftGun.get(MovieSprite);
				spr.rotation._ = -15;
				weapons.push(leftGun);
				
				var rightGun:Entity = WeaponsFactory.createGun(2.4, 10, 220, -30, "gun", gunSound);
				spr = rightGun.get(MovieSprite);
				spr.rotation._ = -15;
				weapons.push(rightGun);
				
				var machGun:Entity = WeaponsFactory.createGun(1, 10, 284, 85, "machineGun", mashinegunSound);
				spr = machGun.get(MovieSprite);
				spr.speed._ = 5;
				weapons.push(machGun);
			case 5:			
				weapons.push(WeaponsFactory.createGun(2, 30, 230, -16, "gun", gunSound));
				
				var upGun:Entity = WeaponsFactory.createGun(1.4, 10, 188, -6, "gun", gunSound);
				spr = upGun.get(MovieSprite);
				spr.setScale(0.5);
				spr.rotation._ = -30;
				weapons.push(upGun);
				
				var downGun:Entity = WeaponsFactory.createGun(1.4, 10, 164, 40, "gun", gunSound);
				spr = downGun.get(MovieSprite);
				spr.setScale(0.5);
				spr.rotation._ = -30;
				weapons.push(downGun);
		}
		return weapons;
	}
	
	static private function getWeapons(id:Int):Array<Entity> {
		var gunSound:String = "sounds/shoot";
		var mashinegunSound:String = "sounds/shoot_mashinegun";
		var weapons:Array<Entity> = new Array<Entity>();
		switch (id) {
			case 1:
				var machineGun = WeaponsFactory.createGun(2, 1, 120, -4, "machineGun", mashinegunSound);
				var spr = machineGun.get(MovieSprite);
				spr.speed._ = 5;
				weapons.push(machineGun);
			case 2:	
				weapons.push(WeaponsFactory.createGun(1.5, 1, 100, -40, "gun", gunSound));
				weapons.push(WeaponsFactory.createGun(1.7, 1, 100, -16, "gun", gunSound));
			case 3:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 116, -35, "gun", gunSound));
			case 4:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 116, -25, "gun", gunSound));
			case 5:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 92, -30, "gun", gunSound));
			case 6:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 110, -4, "gun", gunSound));
			case 7:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 40, -40, "gun", gunSound));
			case 8:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 94, -30, "gun", gunSound));
			case 9:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 84, -26, "gun", gunSound));
			case 10:
				var machineGun = WeaponsFactory.createGun(2, 1, 95, -2, "machineGun", mashinegunSound);
				var spr = machineGun.get(MovieSprite);
				spr.speed._ = 5;
				weapons.push(machineGun);
			case 11:
				weapons.push(WeaponsFactory.createGun(1.4, 1, 110, -40, "gun", gunSound));
		}
		return weapons;
	}
	
}