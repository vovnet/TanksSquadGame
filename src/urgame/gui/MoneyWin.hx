package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import urgame.tools.BigNumber;

/**
 * ...
 * @author Vladimir
 */
class MoneyWin extends Component {
	private var back:ImageSprite;
	private var text:TextSprite;
	private var coin:ImageSprite;

	public function new() {
		back = new ImageSprite(G.pack.getTexture("gui/money_window"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight() / 2);
		
		coin = new ImageSprite(G.pack.getTexture("gui/coin_icon"));
		coin.setXY(14, 20);
		
		text = new TextSprite(new Font(G.pack, "fonts/white_font"), "0");
		text.setAlign(TextAlign.Center);
		text.setXY(120, 20);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.add(back);
		owner.addChild(new Entity().add(coin));
		owner.addChild(new Entity().add(text));
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		text.text = Std.string(BigNumber.format(G.gameData.money));
	}
	
	public function setXY(x:Float, y:Float) {
		back.setXY(x, y);
	}
	
}