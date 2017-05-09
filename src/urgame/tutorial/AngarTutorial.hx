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
class AngarTutorial extends Component {
	private var manager:TutorialManager;
	private var finger:MovieSprite;
	private var connection:SignalConnection;
	private var girl:ImageSprite;
	private var mind:ImageSprite;
	private var text:ImageSprite;
	private var isStart:Bool = false;
	var script:Script;

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
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (G.gameData.money >= 10 && !isStart) {
			isStart = true;
			show();
		}
	}
	
	function show() {
		owner.addChild(new Entity().add(girl));
		owner.addChild(new Entity().add(mind));
		mind.owner.addChild(new Entity().add(text));
		
		script = new Script();
		owner.add(script);
		script.run(new Sequence([
			new CallFunction(showGirl),
			new Delay(0.3),
			new CallFunction(showText)
		]));
	}
	
	private function showGirl() {
		girl.x.animateTo(980, 0.2, Ease.expoOut);
	}
	
	function showText() {
		mind.alpha.animateTo(1, 0.4);
		showFinger();
	}
	
	public function showFinger() {
		finger = EffectsFactory.createEffect("finger");
		finger.disablePointer();
		owner.addChild(new Entity().add(finger));
		finger.setXY(-50, 440);
		//finger.setXY(-50, 660);
		//finger.scaleY._ = -1;
		
		connection = TutorialManager.eventEnterAngar.connect(onEnterToAngar);
	}
	
	function onEnterToAngar() {
		TutorialManager.eventEnterAngar.disconnect(connection);
		connection = TutorialManager.eventUpgradeTank.connect(onUpgradeTank);
		finger.scaleY._ = 1;
		finger.scaleX._ = -1;
		finger.setXY(420, 140);
	}
	
	function onUpgradeTank() {
		TutorialManager.eventUpgradeTank.disconnect(connection);
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
	
	function hideText() {
		mind.alpha.animateTo(0, 0.4);
		owner.removeChild(finger.owner);
	}
	
	function hideGirl() {
		girl.x.animateTo( 1300, 0.2);
	}
	
	function remove() {
		owner.parent.removeChild(owner);
	}
	
}