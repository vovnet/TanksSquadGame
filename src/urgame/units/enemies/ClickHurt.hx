package urgame.units.enemies;

import flambe.Component;
import flambe.display.Sprite;
import flambe.input.PointerEvent;
import urgame.screens.GameScreen;
import urgame.tutorial.TutorialManager;

/**
 * ...
 * @author Vladimir
 */
class ClickHurt extends Component {
	var enemy:Enemy;

	public function new() {
		
	}
	
	override public function onStart() {
		super.onStart();
		var sprite:Sprite = owner.get(Sprite);
		sprite.pointerDown.connect(onClick);
	}
	
	function onClick(e:PointerEvent) {
		enemy = owner.get(Enemy);
		
		var damage:Float = 0;
		for (i in G.gameData.tanks) {
			if (i.isOpen) {
				damage += i.damage * 0.25;
			}
		}
		
		enemy.setDamage(damage, false);
		
		var sprite:Sprite = owner.get(Sprite);
		GameScreen.instance.showClickEffect(sprite.x._, sprite.y._, sprite.getNaturalWidth(), sprite.getNaturalHeight());
		TutorialManager.eventHurtEnemy.emit();
	}
	
}