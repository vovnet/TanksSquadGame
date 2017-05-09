package urgame.ranks;

import flambe.Component;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import urgame.gui.Button;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class AllRanksWindow extends Component {
	private var game:GameScreen;
	

	public function new(game:GameScreen) {
		this.game = game;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		var fade:FillSprite = new FillSprite(0x000000, G.width, G.height);
		fade.setAlpha(0.2);
		owner.addChild(new Entity().add(fade));
		
		var back:ImageSprite = new ImageSprite(G.pack.getTexture("ranks/rank_window"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight() / 2);
		back.setXY(G.width / 2, G.height / 2 - 40);
		owner.addChild(new Entity().add(back));
		
		var rankIndex:Int = 0;
		for (i in 0...2) {
			for (j in 0...5) {
				var rank:ImageSprite = new ImageSprite(G.pack.getTexture(G.gameData.ranks[rankIndex++].imgPath));
				rank.setXY(j * 110 + 42, i * 100 + 110);
				back.owner.addChild(new Entity().add(rank));
			}
		}
		
		var btn:Button = new Button("ranks/yes_button");
		back.owner.addChild(new Entity().add(btn));
		btn.setXY(back.getNaturalWidth() / 2, 360);
		btn.eventClick.connect(onClickButton);
	}
	
	function onClickButton() {
		owner.parent.removeChild(owner);
	}
	
	
	
}