package urgame.screens;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;

/**
 * ...
 * @author Vladimir
 */
class BackgroundGame extends Component {
	private var backs:Array<Entity> = new Array<Entity>();

	public function new() {
		backs.push(makeBackground("backs/back_1_left", "backs/back_1_right"));
		backs.push(makeBackground("backs/back_tanks_2_left", "backs/back_tanks_2_rigth"));
		backs.push(makeBackground("backs/back_tanks_3_left", "backs/back_tanks_3_rigth"));
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(backs[G.gameData.backgroundId]);
	}
	
	public function changeBack() {
		G.gameData.backgroundId = (G.gameData.backgroundId + 1) % backs.length;
		owner.removeChild(owner.firstChild);
		owner.addChild(backs[G.gameData.backgroundId]);
	}
	
	private function makeBackground(nameLeft:String, nameRight:String):Entity {
		var parentBack:Entity = new Entity();
		var left:ImageSprite = new ImageSprite(G.pack.getTexture(nameLeft));
		var right:ImageSprite = new ImageSprite(G.pack.getTexture(nameRight));
		right.setXY(left.getNaturalWidth(), 0);
		parentBack.add(left);
		parentBack.addChild(new Entity().add(right));
		return parentBack;
	}
	
}