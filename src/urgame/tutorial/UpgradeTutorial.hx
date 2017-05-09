package urgame.tutorial;

import flambe.Component;
import flambe.Entity;
import flambe.animation.Ease;
import flambe.display.ImageSprite;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.swf.MovieSprite;
import flambe.util.SignalConnection;
import urgame.effects.EffectsFactory;

/**
 * ...
 * @author Vladimir
 */
class UpgradeTutorial extends Component {
	private var manager:TutorialManager;
	private var girl:ImageSprite;
	private var mind:ImageSprite;
	private var text:ImageSprite;
	private var connection:SignalConnection;
	private var finger:MovieSprite;

	public function new(manager:TutorialManager) {
		this.manager = manager;
		
		girl = new ImageSprite(G.pack.getTexture("tutorials/girl"));
		girl.centerAnchor();
		girl.setXY( 1200, 300);
		girl.disablePointer();
		girl.scaleX._ = -1;
		
		mind = new ImageSprite(G.pack.getTexture("tutorials/mind"));
		mind.centerAnchor();
		mind.setXY(650, 200);
		mind.setAlpha(0);
		mind.disablePointer();
		mind.scaleX._ = -1;
		
		text = new ImageSprite(G.pack.getTexture("tutorials/upgrade_text"));
		text.centerAnchor();
		text.setXY(268, 110);
		text.scaleX._ = -1;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.addChild(new Entity().add(girl));
		owner.addChild(new Entity().add(mind));
		mind.owner.addChild(new Entity().add(text));
		
		var script:Script = new Script();
		owner.add(script);
		script.run(new Sequence([
			new CallFunction(showGirl),
			new Delay(0.3),
			new CallFunction(showText)
		]));
		
	}
	
	private function showGirl() {
		girl.x.animateTo(980, 0.2, Ease.expoOut);
		connection = TutorialManager.eventUpgradeTank.connect(onUpgrade);
	}
	
	function showText() {
		mind.alpha.animateTo(1, 0.4);
		
		finger = EffectsFactory.createEffect("finger");
		finger.disablePointer();
		owner.addChild(new Entity().add(finger));
		finger.setXY(420, 140);
		finger.scaleX._ = -1;
	}
	
	function onUpgrade() {
		TutorialManager.eventUpgradeTank.disconnect(connection);
		manager.tutorialComplete(owner);
	}
	
}