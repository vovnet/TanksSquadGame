package urgame.tutorial;

import flambe.Component;
import flambe.Entity;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal0;

/**
 * ...
 * @author Vladimir
 */
class TutorialManager extends Component {
	static public var eventHurtEnemy:Signal0 = new Signal0();
	static public var eventSkillOn:Signal0 = new Signal0();
	static public var eventEnterAngar:Signal0 = new Signal0();
	static public var eventUpgradeTank:Signal0 = new Signal0();
	static public var eventGiveMoney:Signal0 = new Signal0();
	static public var eventBackToGame:Signal0 = new Signal0();
	
	private var tutorials:Array<Entity> = new Array<Entity>();
	var script:Script;

	public function new() {
		
	}
	
	override public function onAdded() {
		super.onAdded();
		
		tutorials.push(new Entity().add(new WelcomeTutorial(this)).add(new Tutorial(1)));
		tutorials.push(new Entity().add(new HurtEnemyTutorial(this)).add(new Tutorial(2)));
		tutorials.push(new Entity().add(new SkillTutorial(this)).add(new Tutorial(3)));
		tutorials.push(new Entity().add(new AngarTutorial(this)).add(new Tutorial(2)));
		tutorials.push(new Entity().add(new OpenTanksTutorial(this)).add(new Tutorial(1.2)));
		tutorials.push(new Entity().add(new BackToGameTutorial(this)).add(new Tutorial(1)));
		
		script = new Script();
		owner.add(script);
		script.run(new Sequence([new Delay(1), new CallFunction(nextTutorial)]));
	}
	
	public function tutorialComplete(tutor:Entity) {
		tutorials.remove(tutor);
		//owner.removeChild(tutor);
		if (tutorials[0] != null) {
			var nextTut:Tutorial = tutorials[0].get(Tutorial);
			script.run(new Sequence([new Delay(nextTut.elapsed), new CallFunction(nextTutorial)]));
		} else {
			G.gameData.isTutorComplete = true;
		}
	}
	
	private function nextTutorial() {
		if (tutorials[0] != null) {
			owner.addChild(tutorials[0]);
		}
	}
	
	
}