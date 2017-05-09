package urgame.tutorial;

import flambe.Component;
import flambe.Entity;
import flambe.animation.Ease;
import flambe.animation.Sine;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.input.PointerEvent;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;

/**
 * ...
 * @author Vladimir
 */
class OpenTanksTutorial extends Component {
	private var manager:TutorialManager;
	private var fill:FillSprite;
	private var girl:ImageSprite;
	private var mind:ImageSprite;
	private var text:ImageSprite;
	private var contin:ImageSprite;
	var script:Script;

	public function new(manager:TutorialManager) {
		this.manager = manager;
		fill = new FillSprite(0x000000, G.width, G.height);
		
		girl = new ImageSprite(G.pack.getTexture("tutorials/girl"));
		girl.centerAnchor();
		girl.setXY( -200, 300);
		girl.disablePointer();
		
		mind = new ImageSprite(G.pack.getTexture("tutorials/mind"));
		mind.centerAnchor();
		mind.setXY(450, 200);
		mind.setAlpha(0);
		mind.disablePointer();
		
		text = new ImageSprite(G.pack.getTexture("tutorials/when_text"));
		text.centerAnchor();
		text.setXY(268, 110);
		
		contin = new ImageSprite(G.pack.getTexture("tutorials/click_text"));
		contin.setXY(350, 320);
		contin.disablePointer();
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.addChild(new Entity().add(fill));
		owner.addChild(new Entity().add(girl));
		owner.addChild(new Entity().add(mind));
		mind.owner.addChild(new Entity().add(text));
		
		fill.alpha.animate(0, 0.5, 0.3);
		
		script = new Script();
		owner.add(script);
		script.run(new Sequence([
			new CallFunction(showGirl),
			new Delay(0.3),
			new CallFunction(showText),
			new Delay(2),
			new CallFunction(showContinue)
		]));
	}
	
	
	function onClick(e:PointerEvent) {
		manager.tutorialComplete(owner);
		hide();
	}
	
	private function showGirl() {
		girl.x.animateTo(120, 0.2, Ease.expoOut);
	}
	
	function showText() {
		mind.alpha.animateTo(1, 0.4);
	}
	
	function showContinue() {
		owner.addChild(new Entity().add(contin));
		contin.alpha.behavior = new Sine(0, 1, 0.6);
		fill.pointerDown.connect(onClick);
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
		owner.removeChild(contin.owner);
	}
	
	function hideGirl() {
		girl.x.animateTo(-300, 0.2);
		fill.alpha.animateTo(0, 0.4);
	}
	
	function remove() {
		owner.parent.removeChild(owner);
	}
}