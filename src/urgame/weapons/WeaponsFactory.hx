package urgame.weapons;
import flambe.Entity;
import urgame.effects.EffectsFactory;
import urgame.units.Unit;

/**
 * ...
 * @author Vladimir
 */
class WeaponsFactory {

	public function new() {
		
	}
	
	static public function createGun(fireRate:Float, damage:Float, x:Float, y:Float, effectName:String, sound:String):Entity {
		var gun:Entity = new Entity();
		gun.add(new Gun(fireRate, damage, sound));
		var effect = EffectsFactory.createEffect(effectName);
		gun.add(effect);
		effect.setXY(x, y);
		return gun;
	}
	
}