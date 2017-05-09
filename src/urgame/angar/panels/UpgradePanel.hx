package urgame.angar.panels;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.util.Signal0.Listener0;
import format.swf.Data.FontLayoutData;
import urgame.data.TankData;
import urgame.gui.Button;
import urgame.gui.TextButton;
import urgame.tools.BigNumber;
import urgame.tutorial.TutorialManager;

/**
 * ...
 * @author Vladimir
 */
class UpgradePanel extends Component {
	private static inline var UPGRADE_RATE:Float = 1.1;
	private var back:ImageSprite;
	private var data:TankData;
	private var coinIcons:Array<Entity>;
	private var buttons:Array<Entity>;
	private var inactives:Array<Entity>;
	private var maximum:Array<Entity>;
	var damage:TextSprite;
	var crit:TextSprite;
	var health:TextSprite;

	public function new(data:TankData) {
		this.data = data;
		back = new ImageSprite(G.pack.getTexture("gui/angar/upgrade"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight() / 2);
		coinIcons = new Array<Entity>();
		coinIcons[0] = new Entity().add(makeCoin(105, 56));
		coinIcons[1] = new Entity().add(makeCoin(105, 160));
		coinIcons[2] = new Entity().add(makeCoin(105, 264));
		
		inactives = new Array<Entity>();
		inactives[0] = makeInactive(224, 82);
		inactives[1] = makeInactive(224, 186);
		inactives[2] = makeInactive(224, 288);
		
		buttons = new Array<Entity>();
		buttons[0] = makeButton(224, 82, clickUpDamage);
		buttons[1] = makeButton(224, 186, clickUpCrit);
		buttons[2] = makeButton(224, 288, clickUpHealth);
		
		maximum = new Array<Entity>();
		maximum[0] = makeMaximum(200, 60);
		maximum[1] = makeMaximum(200, 165);
		maximum[2] = makeMaximum(200, 267);
	}
	
	
	override public function onAdded() {
		super.onAdded();
		owner.add(back);
		owner.addChild(coinIcons[0]);
		owner.addChild(coinIcons[1]);
		owner.addChild(coinIcons[2]);
		
		owner.addChild(inactives[0]);
		owner.addChild(inactives[1]);
		owner.addChild(inactives[2]);
		
		owner.addChild(buttons[0]);
		owner.addChild(buttons[1]);
		owner.addChild(buttons[2]);
		
		owner.addChild(new Entity().add(makeTextField(124, 10, "fonts/gray_font", "DMG")));
		owner.addChild(new Entity().add(makeTextField(120, 115, "fonts/gray_font", "CRT")));
		owner.addChild(new Entity().add(makeTextField(116, 220, "fonts/gray_font", "HP")));
		
		damage = makeTextField(220, 10, "fonts/blue_font", BigNumber.format(data.damage));
		owner.addChild(new Entity().add(damage));
		
		crit = makeTextField(220, 115, "fonts/blue_font", BigNumber.format(data.crit));
		owner.addChild(new Entity().add(crit));
		
		health = makeTextField(220, 220, "fonts/blue_font", BigNumber.format(data.health));
		owner.addChild(new Entity().add(health));
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		if (data.lvlDamage < G.gameData.maxHeroLevel) {
			updatePriceOnButtons(data.priceUpDamage, 0);
			updateButtonsVisible(data.priceUpDamage, 0);
		} else {
			showMaximum(0);
		}
		
		if (data.lvlCrit < G.gameData.maxHeroLevel) {
			updatePriceOnButtons(data.priceUpCrit, 1);
			updateButtonsVisible(data.priceUpCrit, 1);
		} else {
			showMaximum(1);
		}
		
		if (data.lvlHealth < G.gameData.maxHeroLevel) {
			updatePriceOnButtons(data.priceUpHealth, 2);
			updateButtonsVisible(data.priceUpHealth, 2);
		} else {
			showMaximum(2);
		}
	}
	
	public function setXY(x:Float, y:Float) {
		back.setXY(x, y);
	}
	
	function clickUpDamage() {
		if (G.gameData.money >= data.priceUpDamage) {
			data.lvlDamage++;
			G.gameData.money -= data.priceUpDamage;
			data.priceUpDamage *= UPGRADE_RATE;
			data.damage *= UPGRADE_RATE;
			damage.text = BigNumber.format(data.damage);
			TutorialManager.eventUpgradeTank.emit();
		}
	}
		
	function clickUpCrit() {
		if (G.gameData.money >= data.priceUpCrit) {
			data.lvlCrit++;
			G.gameData.money -= data.priceUpCrit;
			data.priceUpCrit *= UPGRADE_RATE;
			data.crit *= UPGRADE_RATE;
			crit.text = BigNumber.format(data.crit);
			TutorialManager.eventUpgradeTank.emit();
		}
	}
	
	function clickUpHealth() {
		if (G.gameData.money >= data.priceUpHealth) {
			var healthPercent:Float = data.currentHealth / data.health;
			data.lvlHealth++;
			G.gameData.money -= data.priceUpHealth;
			data.priceUpHealth *= UPGRADE_RATE;
			data.health *= UPGRADE_RATE;
			data.currentHealth = healthPercent * data.health;
			health.text = BigNumber.format(data.health);
			TutorialManager.eventUpgradeTank.emit();
		}
	}
	
	private function makeCoin(x:Float, y:Float):ImageSprite {
		var spr:ImageSprite = new ImageSprite(G.pack.getTexture("gui/coin_icon"));
		spr.setXY(x, y);
		return spr;
	}
	
	private function makeButton(x:Float, y:Float, listener:Listener0):Entity {
		var btn:TextButton = new TextButton("gui/button_money", "fonts/coin_button", "555");
		btn.setXY(x, y);
		btn.eventClick.connect(listener);
		return new Entity().add(btn);
	}
	
	private function makeInactive(x:Float, y:Float):Entity {
		var btn:TextButton = new TextButton("gui/button_money_inactive", "fonts/coin_button", "555");
		btn.setXY(x, y);
		return new Entity().add(btn);
	}
	
	private function makeTextField(x:Float, y:Float, font:String, text:String):TextSprite {
		var field:TextSprite = new TextSprite(new Font(G.pack, font), text);
		field.setAlign(TextAlign.Center);
		field.setXY(x, y);
		return field;
	}
	
	private function makeMaximum(x:Float, y:Float):Entity {
		var max:Entity = new Entity();
		var txt:TextSprite = new TextSprite(new Font(G.pack, "fonts/blue_font"), "MAXIMUM");
		txt.setXY(x, y);
		txt.setAlign(TextAlign.Center);
		return max.add(txt);
	}
	
	private function updatePriceOnButtons(price:Float, id:Int) {
		var btn:TextButton = buttons[id].get(TextButton);
		btn.setText(BigNumber.format(price));
		btn = inactives[id].get(TextButton);
		btn.setText(BigNumber.format(price));
	}
	
	private function updateButtonsVisible(price:Float, id:Int) {
		if (G.gameData.money < price) {
			owner.removeChild(buttons[id]);
		} else {
			owner.addChild(buttons[id]);
		}
	}
	
	private function showMaximum(id:Int) {
		owner.removeChild(buttons[id]);
		owner.removeChild(inactives[id]);
		owner.removeChild(coinIcons[id]);
		
		owner.addChild(maximum[id]);
	}
	
}