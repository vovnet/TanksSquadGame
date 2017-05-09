package urgame.gui;

import flambe.Component;
import flambe.display.Font;
import flambe.display.TextSprite;

/**
 * ...
 * @author Vladimir
 */
class AreaLabel extends Component {
	private var text:TextSprite;

	public function new() {
		
	}
	
	override public function onAdded() {
		super.onAdded();
		text = new TextSprite(new Font(G.pack, "fonts/or_font_32"), "AREA");
		owner.add(text);
		text.setAlign(TextAlign.Center);
		text.setXY(G.width / 2, 2);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		text.text = "MISSION " + G.gameData.mission + " / AREA " + G.gameData.level;
		
	}
	
}