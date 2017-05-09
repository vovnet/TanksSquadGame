package urgame.angar;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import urgame.angar.panels.UnlockPanel;
import urgame.angar.panels.UpgradePanel;
import urgame.screens.GameScreen;
import urgame.units.heroes.HeroesFactory;

/**
 * ...
 * @author Vladimir
 */
class Angar extends Component {
	private var game:GameScreen;
	private var upLine:UpLineAngar;
	private var lastTank:Entity;
	
	var upgPanel_1:UpgradePanel;
	var upgPanel_2:UpgradePanel;
	var upgPanel_3:UpgradePanel;
	
	var unlPanel_2:UnlockPanel;
	var unlPanel_3:UnlockPanel;

	public function new(game:GameScreen) {
		this.game = game;
		
		upLine = new UpLineAngar();
		
		upgPanel_1 = new UpgradePanel(G.gameData.tanks[0]);
		upgPanel_1.setXY(250, 324);
		new Entity().add(upgPanel_1);
		
		upgPanel_2 = new UpgradePanel(G.gameData.tanks[1]);
		upgPanel_2.setXY(570, 324);
		new Entity().add(upgPanel_2);
		
		upgPanel_3 = new UpgradePanel(G.gameData.tanks[2]);
		upgPanel_3.setXY(890, 324);
		new Entity().add(upgPanel_3);
		
		unlPanel_2 = new UnlockPanel(1);
		unlPanel_2.setXY(570, 324);
		new Entity().add(unlPanel_2);
		unlPanel_2.eventUnlock.connect(onBuyTank);
		
		unlPanel_3 = new UnlockPanel(2);
		unlPanel_3.setXY(890, 324);
		new Entity().add(unlPanel_3);
		unlPanel_3.eventUnlock.connect(onBuyTank);
		
		var tankImg:ImageSprite = new ImageSprite(G.pack.getTexture("gui/angar/tank_black_2"));
		tankImg.setAnchor(tankImg.getNaturalWidth() / 2, tankImg.getNaturalHeight() / 2);
		tankImg.setXY(880, 260);
		lastTank = new Entity().add(tankImg);
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.add(upLine);
		
		var leftBack:ImageSprite = new ImageSprite(G.pack.getTexture("gui/angar/upgrade_main"));
		var rightBack:ImageSprite = new ImageSprite(G.pack.getTexture("gui/angar/upgrade_main"));
		leftBack.y._ = 130;
		rightBack.scaleX._ = -1;
		rightBack.x._ = leftBack.getNaturalWidth() * 2;
		var backEnt:Entity = new Entity().add(leftBack).addChild(new Entity().add(rightBack));
		owner.addChild(backEnt);
		
		owner.addChild(upgPanel_1.owner);
		
		if (G.gameData.tanks[1].isOpen) {
			owner.addChild(upgPanel_2.owner);
		} else {
			owner.addChild(unlPanel_2.owner);
		}
		
		if (G.gameData.tanks[2].isOpen) {
			owner.addChild(upgPanel_3.owner);
		} else {
			owner.addChild(unlPanel_3.owner);
		}
		
		/*
		if (G.gameData.tanks[1].isOpen) {
			owner.addChild(upgPanel_2.owner);
		} else {
			owner.addChild(unlPanel_2.owner);
		}
		
		
		if (G.gameData.tanks[2].isOpen) {
			owner.addChild(upgPanel_3.owner);
		} else if (G.gameData.tanks[1].isOpen) {
			owner.addChild(unlPanel_3.owner);
		} else {
			owner.addChild(lastTank);
		}
		*/
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
	}
	
	function onBuyTank(idTank:Int) {
		if (idTank == 1) {
			owner.removeChild(unlPanel_2.owner);
			owner.addChild(upgPanel_2.owner);
			
			owner.removeChild(lastTank);
			owner.addChild(unlPanel_3.owner);
		}
		
		if (idTank == 2) {
			owner.removeChild(unlPanel_3.owner);
			owner.addChild(upgPanel_3.owner);
		}
		
		// добавляем танк на карту
		var tank:Entity = HeroesFactory.makeHero(G.gameData.tanks[idTank], game);
		game.gameLayer.addChild(tank);
		game.heroes.push(tank);
	}
	
}