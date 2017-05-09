package urgame.tutorial;

import flambe.Component;
import flambe.Entity;
import flambe.swf.MovieSprite;
import flambe.util.SignalConnection;
import urgame.effects.EffectsFactory;

/**
 * ...
 * @author Vladimir
 */
class BackToGameTutorial extends Component {
	private var manager:TutorialManager;
	private var finger:MovieSprite;
	private var connection:SignalConnection;

	public function new(manager:TutorialManager) {
		this.manager = manager;
	}
	
	override public function onAdded() {
		super.onAdded();
		finger = EffectsFactory.createEffect("finger");
		finger.disablePointer();
		owner.addChild(new Entity().add(finger));
		finger.setXY(-50, 440);
		//finger.scaleY._ = -1;
	}
	
	override public function onStart() {
		super.onStart();
		connection = TutorialManager.eventBackToGame.connect(onEnterToAngar);
	}
	
	function onEnterToAngar() {
		TutorialManager.eventBackToGame.disconnect(connection);
		manager.tutorialComplete(owner);
		owner.parent.removeChild(owner);
	}
	
}