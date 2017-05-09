package urgame.effects;
import flambe.Component;
import flambe.Entity;
import flambe.swf.Flipbook;
import flambe.swf.Library;
import flambe.swf.MovieSprite;

/**
 * ...
 * @author Vladimir
 */
class EffectsFactory {
	static private var lib:Library;

	public function new() {}
	
	static public function createEffect(name:String):MovieSprite {
		if (lib == null) {
			init();
		}
		return lib.createMovie(name);
	}
	
	static private function init() {
		lib = Library.fromFlipbooks([
			makeFlipbook("machineGun", "effects/machine_gun/MG_", 3),
			makeFlipbook("gun", "effects/gun/gun_", 25),
			makeFlipbook("repairSkill", "effects/repair/repair_", 30),
			makeFlipbook("fieldSkill", "effects/forse_field/forse_field_", 41),
			makeFlipbook("explosion", "effects/explosion/expl_", 19),
			makeFlipbook("gear", "effects/gear/gear_", 20),
			makeFlipbook("click", "effects/click/click_", 4),
			makeFlipbook("finger", "tutorials/finger/finger_", 20),
			makeFlipbook("big_explosion", "effects/big_explosion/explosion_", 19)
		]);
	}
	
	static private function makeFlipbook(name:String, path:String, frames:Int):Flipbook {
		return new Flipbook(name, [for (frame in 1...frames + 1) G.pack.getTexture(path + frame)]);
	}
	
}