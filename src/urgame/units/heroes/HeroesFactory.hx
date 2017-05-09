package urgame.units.heroes;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.swf.MovieSprite;
import urgame.data.TankData;
import urgame.effects.EffectsFactory;
import urgame.gui.ProgressBar;
import urgame.screens.GameScreen;
import urgame.weapons.Gun;
import urgame.weapons.WeaponsFactory;

/**
 * ...
 * @author Vladimir
 */
class HeroesFactory {

	public function new() { }

	static public function makeHero(data:TankData, game:GameScreen):Entity {
		var tank:Entity = new Entity();
		var t = new ImageSprite(G.pack.getTexture(data.img));
		t.anchorX._ = t.getNaturalHeight() / 2;
		t.anchorY._ = t.getNaturalHeight();
		var hero:HeroAI = new HeroAI(game, t);
		
		var backBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/bars/hp_4"));
		var fillBar:ImageSprite = new ImageSprite(G.pack.getTexture("gui/bars/hp_3"));
		
		var shadow:ImageSprite = new ImageSprite(G.pack.getTexture("tanks/shadow_small"));
		shadow.setAnchor(shadow.getNaturalWidth() / 2, shadow.getNaturalHeight() / 2);
		shadow.setXY(data.x, data.y);
		
		var gearMovie:MovieSprite = EffectsFactory.createEffect("gear");
		gearMovie.setAnchor(gearMovie.getNaturalWidth() / 2, gearMovie.getNaturalHeight() / 2);
		gearMovie.setXY(40, -80);
		var gear:Entity = new Entity()
			.add(gearMovie)
			.add(new GearEffect(hero));
		
		var tankEnt:Entity = new Entity().add(shadow).addChild(new Entity().add(t));
		tankEnt.addChild(gear);
		var tank:Entity = new Entity()
			.addChild(tankEnt)
			.add(hero)
			.add(new Data(data))
			.add(new ProgressBar(backBar, fillBar, data.x, data.y + 20, hero.percentHealth));
		
		switch (data.id) {
			case 1:
				t.setXY(36, shadow.getNaturalHeight() / 2);
				var gun = WeaponsFactory.createGun(3, 10, data.x + 30, data.y - 126, "gun", "sounds/shoot");
				tank.addChild(gun);
			case 2:
				t.setXY(60, shadow.getNaturalHeight() / 2);
				var gun = WeaponsFactory.createGun(1.5, 10, data.x + 12, data.y - 134, "gun", "sounds/shoot");
				tank.addChild(gun);
			case 3:
				t.setXY(70, shadow.getNaturalHeight() / 2);
				var gun = WeaponsFactory.createGun(1.5, 10, data.x + 30, data.y - 108, "machineGun", "sounds/shoot_mashinegun");
				var sp = gun.get(MovieSprite);
				sp.speed._ = 5;
				tank.addChild(gun);
		}
		return tank;
	}
	
	
	
	
}