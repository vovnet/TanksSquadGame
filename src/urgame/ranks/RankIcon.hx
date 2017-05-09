package urgame.ranks;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.input.PointerEvent;
import flambe.util.Signal0;

/**
 * ...
 * @author Vladimir
 */
class RankIcon extends Component {
	public var eventClick:Signal0 = new Signal0();
	
	private var billet:ImageSprite;
	private var text:TextSprite;
	private var icon:ImageSprite;

	public function new() {
		
	}
	
	override public function onAdded() {
		super.onAdded();
		billet = new ImageSprite(G.pack.getTexture("ranks/gui_tanks_rank"));
		owner.addChild(new Entity().add(billet));
		text = new TextSprite(new Font(G.pack, "fonts/white_36"), G.gameData.ranks[G.gameData.rankId].name);
		text.setAlign(TextAlign.Center);
		text.setXY(110, 4);
		
		icon = new ImageSprite(G.pack.getTexture(G.gameData.ranks[G.gameData.rankId].imgPath));
		icon.setXY(-70, -24);
		
		billet.owner.addChild(new Entity().add(text));
		billet.owner.addChild(new Entity().add(icon));
		
		billet.pointerDown.connect(onClick);
	}
	
	public function setXY(x:Float, y:Float) {
		billet.setXY(x, y);
	}
	
	function onClick(e:PointerEvent) {
		eventClick.emit();
	}
	
}