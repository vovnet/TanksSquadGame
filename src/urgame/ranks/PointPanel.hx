package urgame.ranks;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import urgame.gui.Button;

/**
 * ...
 * @author Vladimir
 */
class PointPanel extends Component {
	private var id:Int;
	private var plusBtn:Button;
	private var minusBtn:Button;
	private var pointText:TextSprite;
	private var points:Int = 0;
	var back:ImageSprite;
	
	public function new(id:Int) {
		this.id = id;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		back = new ImageSprite(G.pack.getTexture("ranks/points"));
		owner.addChild(new Entity().add(back));
		
		var icon:ImageSprite = new ImageSprite(G.pack.getTexture("ranks/icon_" + id));
		icon.setXY(4, 4);
		back.owner.addChild(new Entity().add(icon));
		
		pointText = new TextSprite(new Font(G.pack, "fonts/white_36"), Std.string(points));
		pointText.setAlign(TextAlign.Center);
		pointText.setXY(130, 20);
		back.owner.addChild(new Entity().add(pointText));
		
		plusBtn = new Button("ranks/plus");
		plusBtn.setXY(70, 116);
		plusBtn.eventClick.connect(onClickPlus);
		back.owner.addChild(new Entity().add(plusBtn));
		
		minusBtn = new Button("ranks/minus");
		minusBtn.setXY(121, 116);
		minusBtn.eventClick.connect(onClickMinus);
		back.owner.addChild(new Entity().add(minusBtn));
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		pointText.text = Std.string(points);
	}
	
	public function getPoints():Int {
		return points;
	}
	
	public function setPoints(value:Int) {
		points = value;
	}
	
	public function setXY(x:Float, y:Float) {
		back.setXY(x, y);
	}
	
	function onClickPlus() {
		if (G.gameData.upgradePoints > 0) {
			G.gameData.upgradePoints--;
			points++;
		}
	}
	
	function onClickMinus() {
		if (points > 0) {
			points--;
			G.gameData.upgradePoints++;
		}
	}
	
	
}