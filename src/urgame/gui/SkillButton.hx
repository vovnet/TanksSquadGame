package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.input.PointerEvent;
import flambe.util.Signal1;
import urgame.screens.GameScreen;
import urgame.tools.TimeFormatter;

/**
 * ...
 * @author Vladimir
 */
class SkillButton extends Component {
	public var eventClick:Signal1<Int> = new Signal1<Int>();
	public var id:Int;
	
	private var game:GameScreen;
	
	private var timeSkill:Float;
	private var delay:Float = 0;
	
	private var btn:Button;
	private var lockImage:ImageSprite;
	private var deactiveBtn:ImageSprite;
	private var timerText:TextSprite;
	
	public function new(id:Int, imageName:String, deactiveName:String, timeSkill:Float, game:GameScreen) {
		this.id = id;
		this.timeSkill = timeSkill;
		this.game = game;
		
		deactiveBtn = new ImageSprite(G.pack.getTexture(deactiveName));
		deactiveBtn.setAnchor(deactiveBtn.getNaturalWidth() / 2, deactiveBtn.getNaturalHeight() / 2);
		btn = new Button(imageName);
		btn.eventClick.connect(onClickButton);
		new Entity().add(btn);
		lockImage = new ImageSprite(G.pack.getTexture("gui/skill_lock"));
		lockImage.setAnchor(lockImage.getNaturalWidth() / 2, lockImage.getNaturalHeight() / 2);
		lockImage.setXY(deactiveBtn.getNaturalWidth() / 2, deactiveBtn.getNaturalHeight() / 2);
		
		timerText = new TextSprite(new Font(G.pack, "fonts/time_font"), "12:09");
		timerText.setAlign(TextAlign.Center);
		timerText.setXY(deactiveBtn.getNaturalWidth() / 2, 44);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		new Entity().add(timerText);
		owner.addChild(new Entity().add(deactiveBtn));
		deactiveBtn.owner.addChild(new Entity().add(lockImage));
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		updateLockImage();
		
		if (!game.isAngar && G.gameData.tanks[id - 1].currentHealth > 0) delay -= dt;
		
		if (delay <= 0 && G.gameData.tanks[id - 1].isOpen) {
			owner.addChild(btn.owner);
		}
		timerText.text = TimeFormatter.minutesFormat(Std.int(delay));
	}
	
	
	public function setXY(x:Float, y:Float) {
		deactiveBtn.setXY(x, y);
		btn.setXY(x, y);
	}
	
	function onClickButton() {
		if (game.isAngar || G.gameData.tanks[id - 1].currentHealth <= 0) return;
		
		eventClick.emit(id);
		delay = timeSkill;
		owner.removeChild(btn.owner);
	}
	
	function updateLockImage():Void {
		if (G.gameData.tanks[id - 1].isOpen) {
			deactiveBtn.owner.removeChild(lockImage.owner);
			deactiveBtn.owner.addChild(timerText.owner);
		} else {
			deactiveBtn.owner.addChild(lockImage.owner);
		}
	}
	
}