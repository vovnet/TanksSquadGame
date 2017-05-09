package urgame.angar.panels;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import flambe.util.Signal0;
import flambe.util.Signal1;
import urgame.data.GameData;
import urgame.gui.TextButton;

/**
 * ...
 * @author Vladimir
 */
class UnlockPanel extends Component {
	public var eventUnlock:Signal1<Int> = new Signal1<Int>();
	
	private static var tanksImg:Array<String> = new Array<String>();
	
	private var lockBack:ImageSprite;
	private var idTank:Int;
	private var inactiveBtn:TextButton;
	private var buyBtn:TextButton;
	private var buyBtnEntity:Entity;

	public function new(idTank:Int) {
		this.idTank = idTank;
		tanksImg.push("gui/angar/tank_black_1");
		tanksImg.push("gui/angar/tank_black_2");
		lockBack = new ImageSprite(G.pack.getTexture("gui/angar/unlock_panel"));
		lockBack.setAnchor(lockBack.getNaturalWidth() / 2, lockBack.getNaturalHeight() / 2);
		
		inactiveBtn = new TextButton("gui/angar/unlock_buton", "fonts/gray_font", Std.string(G.gameData.priceTanks[idTank - 1]));
		inactiveBtn.setXY(lockBack.getNaturalWidth() / 2, 270);
		
		buyBtn = new TextButton("gui/angar/unlock_buton_1", "fonts/gray_font", Std.string(G.gameData.priceTanks[idTank - 1]));
		buyBtn.setXY(lockBack.getNaturalWidth() / 2, 270);
		buyBtn.eventClick.connect(onClickBuyButton);
		buyBtnEntity = new Entity().add(buyBtn);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.add(lockBack);
		
		var tank:ImageSprite = new ImageSprite(G.pack.getTexture(tanksImg[idTank - 1]));
		tank.setAnchor(tank.getNaturalWidth() / 2, tank.getNaturalHeight() / 2);
		tank.setXY(lockBack.getNaturalWidth() / 2, 100);
		owner.addChild(new Entity().add(tank));
		
		owner.addChild(new Entity().add(inactiveBtn));
		owner.addChild(buyBtnEntity);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		if (G.gameData.money < G.gameData.priceTanks[idTank - 1]) {
			owner.removeChild(buyBtnEntity);
		} else {
			owner.addChild(buyBtnEntity);
		}
	}
	
	public function setXY(x:Float, y:Float) {
		lockBack.setXY(x, y);
	}
	
	function onClickBuyButton() {
		if (G.gameData.money >= G.gameData.priceTanks[idTank - 1]) {
			eventUnlock.emit(idTank);
			G.gameData.money -= G.gameData.priceTanks[idTank - 1];
			G.gameData.tanks[idTank].isOpen = true;
		}
	}
}