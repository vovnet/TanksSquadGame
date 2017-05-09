package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.animation.AnimatedFloat;
import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.input.PointerEvent;
import flambe.scene.Scene;
import urgame.angar.Angar;
import urgame.screens.GameScreen;
import urgame.tutorial.TutorialManager;

/**
 * ...
 * @author Vladimir
 */
class MainPanel extends Component {
	private var game:GameScreen;
	private var back:ImageSprite;
	private var repairSkillBtn:SkillButton;
	private var protectSkillBtn:SkillButton;
	private var rocketsSkillBtn:SkillButton;
	private var garageButtonEntity:Entity;
	private var backButtonEntity:Entity;
	private var garageBtn:Button;
	private var backBtn:Button;
	private var isGarage:Bool = false;
	private var angarEntity:Entity;
	var backEntity:Entity;
	private var moneyWindow:MoneyWin;
	private var rankButton:Button;
	private var soundButton:Button;
	private var muteButton:Button;
	private var attention:ImageSprite;

	public function new(x:Float, y:Float, game:GameScreen) {
		this.game = game;
		
		back = new ImageSprite(G.pack.getTexture("gui/main_1"));
		
		repairSkillBtn = new SkillButton(1, "gui/skill_3", "gui/skill_black_3", 15, game);
		protectSkillBtn = new SkillButton(2, "gui/skill_2", "gui/skill_black_2", 30, game);
		rocketsSkillBtn = new SkillButton(3, "gui/skill_1", "gui/skill_black_1", 50, game);
		
		back.setXY(x, y);
		repairSkillBtn.setXY(418, 79);
		protectSkillBtn.setXY(568, 79);
		rocketsSkillBtn.setXY(718, 79);
		
		repairSkillBtn.eventClick.connect(onClickSkillButton);
		protectSkillBtn.eventClick.connect(onClickSkillButton);
		rocketsSkillBtn.eventClick.connect(onClickSkillButton);
		
		garageBtn = new Button("gui/button_angar");
		garageBtn.setXY(42, 84);
		garageBtn.setScaleXY( -1, 1);
		garageBtn.eventClick.connect(onClickGarage);
		
		backBtn = new Button("gui/button_back");
		backBtn.setXY(42, 84);
		backBtn.setScaleXY( -1, 1);
		backBtn.eventClick.connect(onClickBack);
		
		rankButton = new Button("gui/rank/new_rank");
		rankButton.setXY(916, 80);
		rankButton.eventClick.connect(onClickNewRank);
		
		angarEntity = new Entity().add(new Angar(game));
		
		moneyWindow = new MoneyWin();
		moneyWindow.setXY(220, 80);
		
		muteButton = new Button("gui/button_mute");
		soundButton = new Button("gui/button_sound");
		muteButton.setXY(1094, 84);
		soundButton.setXY(1094, 84);
		muteButton.eventClick.connect(onClickMuteButton);
		soundButton.eventClick.connect(onClickSoundButton);
		
		attention = new ImageSprite(G.pack.getTexture("gui/attention"));
		attention.setXY(155, -28);
		attention.alpha.behavior = new Sine(0, 1, 0.3);
		attention.disablePointer();
		new Entity().add(attention);
		
		
	}
	
	function onClickMuteButton() {
		backEntity.addChild(soundButton.owner);
		System.volume.animate(0, 1, 0.5);
		G.isOnSound = true;
	}
	
	function onClickSoundButton() {
		backEntity.removeChild(soundButton.owner);
		System.volume.animate(1, 0, 0.5);
		G.isOnSound = false;
	}
	
	function onClickBack() {
		if (isGarage) {
			isGarage = false;
			game.isAngar = false;
			game.owner.removeChild(angarEntity);
			game.owner.addChild(game.gameLayer, false);
			backEntity.removeChild(backButtonEntity);
			backEntity.addChild(garageButtonEntity);
			TutorialManager.eventBackToGame.emit();
		}
	}
	
	function onClickGarage() {
		if (!isGarage) {
			isGarage = true;
			game.isAngar = true;
			game.owner.removeChild(game.gameLayer);
			game.owner.addChild(angarEntity, false);
			backEntity.removeChild(garageButtonEntity);
			backEntity.addChild(backButtonEntity);
			TutorialManager.eventEnterAngar.emit();
		} 
	}
	
	function onClickSkillButton(id:Int) {
		switch (id) {
			case 1:
				game.repairSkillOn();
				G.pack.getSound("sounds/repair").play();
				TutorialManager.eventSkillOn.emit();
			case 2:
				game.fieldSkillOn();
				G.pack.getSound("sounds/def_field").play();
			case 3:
				game.rocketSkillOn();
		}
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		if (G.isOnSound) {
			backEntity.addChild(soundButton.owner);
		} else {
			backEntity.removeChild(soundButton.owner);
		}
		
		if (isShowRankButton()) {
			backEntity.addChild(rankButton.owner);
		} else {
			backEntity.removeChild(rankButton.owner);
		}
		
	}
	
	override public function onAdded() {
		super.onAdded();
		garageButtonEntity = new Entity().add(garageBtn);
		backButtonEntity = new Entity().add(backBtn);
		
		backEntity = new Entity().add(back);
		owner.addChild(backEntity);
		var back2 = new ImageSprite(G.pack.getTexture("gui/main_1"));
		back2.setScaleXY( -1, 1);
		back2.setXY(1136, 0);
		backEntity.addChild(new Entity().add(back2));
		backEntity.addChild(new Entity().add(repairSkillBtn));
		backEntity.addChild(new Entity().add(rocketsSkillBtn));
		backEntity.addChild(new Entity().add(protectSkillBtn));
		backEntity.addChild(new Entity().add(rankButton));
		backEntity.addChild(garageButtonEntity);
		backEntity.addChild(new Entity().add(muteButton));
		backEntity.addChild(new Entity().add(soundButton));
		
		backEntity.addChild(new Entity().add(moneyWindow));
		rankButton.owner.addChild(attention.owner);
		
		var androidBtn:Button = new Button("android_small");
		androidBtn.setXY(920, 80);
		androidBtn.eventClick.connect(onClickAndroidBtn);
		backEntity.addChild(new Entity().add(androidBtn));
	}
	
	function onClickAndroidBtn() {
		System.web.openBrowser(G.androidLink);
	}
	
	function onClickNewRank() {
		game.showYesNoRanksPop();
	}
	
	function isShowRankButton():Bool {
		var isMaxUpgradeTanks:Bool = false;
		for (i in G.gameData.tanks) {
			if (i.isOpen && 
					i.lvlCrit >= G.gameData.maxHeroLevel &&
					i.lvlDamage >= G.gameData.maxHeroLevel &&
					i.lvlHealth >= G.gameData.maxHeroLevel) 
			{
				isMaxUpgradeTanks = true;
			} else {
				isMaxUpgradeTanks = false;
				break;
			}
		}
		return isMaxUpgradeTanks;
	}
	
}