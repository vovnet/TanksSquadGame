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
class SkillTutorial extends Component {
	private var manager:TutorialManager;
	private var finger:MovieSprite;
	private var girl:ImageSprite;
	private var mind:ImageSprite;
	private var text:ImageSprite;
	private var connection:SignalConnection;
	private var script:Script;

	public function new(manager:TutorialManager) {
		this.manager = manager;
		
		girl = new ImageSprite(G.pack.getTexture("tutorials/girl"));
		girl.centerAnchor();
		girl.setXY( -200, 300);
		girl.disablePointer();
		
		mind = new ImageSprite(G.pack.getTexture("tutorials/mind"));
		mind.centerAnchor();
		mind.setXY(450, 200);
		mind.setAlpha(0);
		mind.disablePointer();
		
		text = new ImageSprite(G.pack.getTexture("tutorials/skills"));
		text.centerAnchor();
		text.setXY(268, 110);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.addChild(new Entity().add(girl));
		owner.addChild(new Entity().add(mind));
		mind.owner.addChild(new Entity().add(text));
		
		script = new Script();
		owner.add(script);
		script.run(new Sequence([
			new CallFunction(showGirl),
			new Delay(0.3),
			new CallFunction(showText),
		]));
		
		
	}
	
	private function showGirl() {
		girl.x.animateTo(120, 0.2, Ease.expoOut);
	}
	
	function showText() {
		mind.alpha.animateTo(1, 0.4);
		showFinger();
	}
	
	function onSkill() {
		TutorialManager.eventHurtEnemy.disconnect(connection);
		manager.tutorialComplete(owner);
		hide();
	}
	
	function hide() {
		script.run(new Sequence([
			new CallFunction(hideText),
			new Delay(0.3),
			new CallFunction(hideGirl),
			new Delay(0.8),
			new CallFunction(remove)
		]));
	}
	
	function showFinger() {
		finger = EffectsFactory.createEffect("finger");
		finger.disablePointer();
		owner.addChild(new Entity().add(finger));
		finger.setXY(310, 440);
		//finger.setXY(310, 660);
		//finger.scaleY._ = -1;
		
		connection = TutorialManager.eventSkillOn.connect(onSkill);
	}
	
	function hideText() {
		mind.alpha.animateTo(0, 0.4);
		owner.removeChild(finger.owner);
	}
	
	function hideGirl() {
		girl.x.animateTo( -200, 0.2);
	}
	
	function remove() {
		owner.parent.removeChild(owner);
	}
	
}