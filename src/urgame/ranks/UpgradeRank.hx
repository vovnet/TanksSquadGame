package urgame.ranks;

import flambe.Component;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.Font.TextAlign;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.scene.Scene;
import flambe.scene.SlideTransition;
import urgame.gui.Button;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class UpgradeRank extends Component {
	private var game:GameScreen;
	var yesBtn:Button;
	var text:TextSprite;
	var back:ImageSprite;
	
	var panelDamage:PointPanel;
	var panelCrit:PointPanel;
	var panelHealth:PointPanel;
	
	public function new(game:GameScreen) {
		this.game = game;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		var fade:FillSprite = new FillSprite(0x000000, G.width, G.height);
		fade.setAlpha(0.4);
		owner.addChild(new Entity().add(fade));
		
		back = new ImageSprite(G.pack.getTexture("ranks/rank_window"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight() / 2);
		back.setXY(G.width / 2, G.height / 2 - 40);
		owner.addChild(new Entity().add(back));
		
		text = new TextSprite(new Font(G.pack, "fonts/white_36"), "UPGRADE POINTS: " + G.gameData.upgradePoints);
		text.setAlign(TextAlign.Center);
		text.setXY(back.getNaturalWidth() / 2, 100);
		back.owner.addChild(new Entity().add(text));
		
		var yesWhiteBtn:Button = new Button("ranks/yes_white_left_button");
		yesWhiteBtn.setXY(266, 360);
		back.owner.addChild(new Entity().add(yesWhiteBtn));
		
		yesBtn = new Button("ranks/yes_left_button");
		yesBtn.eventClick.connect(onClickYesButton);
		yesBtn.setXY(266, 360);
		new Entity().add(yesBtn);
		
		var noBtn:Button = new Button("ranks/no_right_button");
		noBtn.eventClick.connect(onClickNoButton);
		noBtn.setXY(356, 360);
		back.owner.addChild(new Entity().add(noBtn));
		
		panelDamage = makePointPanel(1, 20, 160);
		panelCrit = makePointPanel(2, 220, 160);
		panelHealth = makePointPanel(3, 420, 160);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		text.text = "UPGRADE POINTS: " + G.gameData.upgradePoints;
		if (G.gameData.upgradePoints <= 0) {
			back.owner.addChild(yesBtn.owner);
		} else {
			back.owner.removeChild(yesBtn.owner);
		}
	}
	
	function onClickNoButton() {
		panelCrit.setPoints(0);
		panelDamage.setPoints(0);
		panelHealth.setPoints(0);
		owner.parent.removeChild(owner);
	}
	
	function onClickYesButton() {
		owner.parent.removeChild(owner);
		
		if (G.gameData.rankId + 1 < G.gameData.ranks.length) G.gameData.rankId++;
		
		G.gameData.reset(
			panelHealth.getPoints() * 5, 
			panelDamage.getPoints() * 5, 
			panelCrit.getPoints() * 5
		);
		
		var trans:SlideTransition = new SlideTransition(0.4).down();
		G.director.unwindToScene(new Entity().add(new Scene()).add(new GameScreen()), trans);
	}
	
	private function makePointPanel(id:Int, x:Float, y:Float):PointPanel {
		var panel:PointPanel = new PointPanel(id);
		back.owner.addChild(new Entity().add(panel));
		panel.setXY(x, y);
		return panel;
	}
	
}