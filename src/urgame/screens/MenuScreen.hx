package urgame.screens;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.ImageSprite;
import flambe.scene.Scene;
import flambe.scene.SlideTransition;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import format.tools.Image;
import urgame.gui.Button;

/**
 * ...
 * @author Vladimir
 */
class MenuScreen extends Component {
	var logo:ImageSprite;
	var playBtn:Button;
	var moreBtn:Button;
	var muteSoundBtn:Button;
	var soundBtn:Button;

	public function new() {
		
	}
	
	override public function onAdded() {
		super.onAdded();
		var leftBack:ImageSprite = new ImageSprite(G.pack.getTexture("main_screen/main_back_left"));
		owner.add(leftBack);
		
		var rightBack:ImageSprite = new ImageSprite(G.pack.getTexture("main_screen/main_back_right"));
		rightBack.setXY(leftBack.getNaturalWidth(), 0);
		owner.addChild(new Entity().add(rightBack));
		
		logo = new ImageSprite(G.pack.getTexture("main_screen/tank"));
		logo.setAnchor(logo.getNaturalWidth() / 2, logo.getNaturalHeight() / 2);
		logo.setXY(G.width / 2, 160);
		logo.setScale(0);
		owner.addChild(new Entity().add(logo));
		
		playBtn = new Button("main_screen/play_button");
		playBtn.setXY(G.width / 2, 550);
		playBtn.normalSprite.setScale(0);
		playBtn.eventClick.connect(onClickPlay);
		owner.addChild(new Entity().add(playBtn));
		
		moreBtn = new Button("android");
		moreBtn.setXY(190, 550);
		moreBtn.normalSprite.setScale(0);
		moreBtn.eventClick.connect(onClickMore);
		owner.addChild(new Entity().add(moreBtn));
		
		muteSoundBtn = new Button("main_screen/mute_sound");
		muteSoundBtn.setXY(1020, 550);
		muteSoundBtn.normalSprite.setScale(0);
		muteSoundBtn.eventClick.connect(onClickMute);
		owner.addChild(new Entity().add(muteSoundBtn));
		
		soundBtn = new Button("main_screen/sound_button");
		soundBtn.setXY(1020, 550);
		soundBtn.normalSprite.setScale(0);
		soundBtn.eventClick.connect(onClickSound);
		owner.addChild(new Entity().add(soundBtn));
		
		var script:Script = new Script();
		script.run(new Sequence([
			new Delay(0.6), 
			new CallFunction(showLogo), 
			new Delay(0.6), 
			new CallFunction(showPlayButton),
			new Delay(0.2),
			new CallFunction(showMoreButton),
			new Delay(0.2),
			new CallFunction(showSoundButtons)
		]));
		owner.add(script);
		
		G.pack.getSound("sounds/defence_line").loop().volume.animate(0, 0.4, 0.5);
	}
	
	
	function onClickMore() {
		System.web.openBrowser(G.androidLink);
	}
	
	function onClickSound() {
		System.volume.animate(1, 0, 0.3);
		owner.removeChild(soundBtn.owner);
		G.isOnSound = false;
	}
	
	function onClickMute() {
		System.volume.animate(0, 1, 0.3);
		owner.addChild(soundBtn.owner);
		G.isOnSound = true;
	}
	
	function onClickPlay() {
		var trans:SlideTransition = new SlideTransition(0.4).down();
		G.director.unwindToScene(new Entity().add(new Scene()).add(new GameScreen()), trans);
	}
	
	private function showLogo() {
		logo.scaleX.animate(0, 1, 0.4, Ease.backOut);
		logo.scaleY.animate(0, 1, 0.4, Ease.backOut);
	}
	
	private function showPlayButton() {
		playBtn.normalSprite.scaleX.animate(0, 1, 0.4, Ease.backOut);
		playBtn.normalSprite.scaleY.animate(0, 1, 0.4, Ease.backOut);
	}
	
	private function showMoreButton() {
		moreBtn.normalSprite.scaleX.animate(0, 1, 0.4, Ease.backOut);
		moreBtn.normalSprite.scaleY.animate(0, 1, 0.4, Ease.backOut);
	}
	
	private function showSoundButtons() {
		soundBtn.normalSprite.scaleX.animate(0, 1, 0.4, Ease.backOut);
		soundBtn.normalSprite.scaleY.animate(0, 1, 0.4, Ease.backOut);
		
		muteSoundBtn.normalSprite.scaleX.animate(0, 1, 0.4, Ease.backOut);
		muteSoundBtn.normalSprite.scaleY.animate(0, 1, 0.4, Ease.backOut);
	}
	
}