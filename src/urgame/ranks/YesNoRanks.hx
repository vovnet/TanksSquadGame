package urgame.ranks;

import flambe.Component;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.scene.Scene;
import urgame.gui.Button;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class YesNoRanks extends Component {
	private var game:GameScreen;

	public function new(game:GameScreen) {
		this.game = game;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		var fade:FillSprite = new FillSprite(0x000000, G.width, G.height);
		fade.setAlpha(0.4);
		owner.addChild(new Entity().add(fade));
		
		var back:ImageSprite = new ImageSprite(G.pack.getTexture("ranks/rank_window"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight() / 2);
		back.setXY(G.width / 2, G.height / 2 - 40);
		owner.addChild(new Entity().add(back));
		
		var text:TextSprite = new TextSprite(new Font(G.pack, "fonts/gray_font"), "Congratulations! \nYou increase in rank!");
		text.setAlign(TextAlign.Center);
		text.setXY(back.getNaturalWidth() / 2, 100);
		back.owner.addChild(new Entity().add(text));
		
		var quest:TextSprite = new TextSprite(new Font(G.pack, "fonts/gray_font"), "The current mission will be completed.");
		quest.setAlign(TextAlign.Center);
		quest.setXY(back.getNaturalWidth() / 2, 280);
		back.owner.addChild(new Entity().add(quest));
		
		var id:Int = (G.gameData.rankId + 1 < G.gameData.ranks.length) ? G.gameData.rankId + 1 : G.gameData.rankId;
		var nextRank:ImageSprite = new ImageSprite(G.pack.getTexture(G.gameData.ranks[id].imgPath));
		nextRank.setAnchor(nextRank.getNaturalWidth() / 2, nextRank.getNaturalHeight() / 2);
		nextRank.setXY(back.getNaturalWidth() / 2, 228);
		back.owner.addChild(new Entity().add(nextRank));
		
		var yesBtn:Button = new Button("ranks/yes_left_button");
		yesBtn.eventClick.connect(onClickYesButton);
		yesBtn.setXY(266, 360);
		back.owner.addChild(new Entity().add(yesBtn));
		
		var noBtn:Button = new Button("ranks/no_right_button");
		noBtn.eventClick.connect(onClickNoButton);
		noBtn.setXY(356, 360);
		back.owner.addChild(new Entity().add(noBtn));
	}
	
	function onClickNoButton() {
		owner.parent.removeChild(owner);
	}
	
	function onClickYesButton() {
		owner.parent.removeChild(owner);
		
		G.gameData.upgradePoints = 10;
		game.showUpgradeRankPop();
	}
	
}