package urgame.angar;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;

/**
 * ...
 * @author Vladimir
 */
class UpLineAngar extends Component {
	private var leftLine:ImageSprite;
	private var rightLine:ImageSprite;
	private var tank1:ImageSprite;
	private var tank2:ImageSprite;
	private var tank3:ImageSprite;

	public function new() {
		leftLine = new ImageSprite(G.pack.getTexture("gui/angar/back_angar_1"));
		rightLine = new ImageSprite(G.pack.getTexture("gui/angar/back_angar_2"));
		rightLine.setXY(leftLine.getNaturalWidth(), 0);
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(new Entity().add(leftLine));
		owner.addChild(new Entity().add(rightLine));
		
		tank1 = createTank(1, 240, 136);
		tank2 = createTank(2, 580, 136);
		tank3 = createTank(3, 910, 136);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		tank1.visible = G.gameData.tanks[0].isOpen;
		tank2.visible = G.gameData.tanks[1].isOpen;
		tank3.visible = G.gameData.tanks[2].isOpen;
		
	}
	
	private function createTank(id:Int, x:Float, y:Float):ImageSprite {
		var tank:Entity = new Entity();
		var back:ImageSprite = new ImageSprite(G.pack.getTexture("gui/angar/lite"));
		back.setAnchor(back.getNaturalWidth() / 2, back.getNaturalHeight());
		tank.add(back);
		back.setXY(x, y);
		var sprite:ImageSprite = new ImageSprite(G.pack.getTexture("tanks/hero_" + id));
		sprite.setAnchor(sprite.getNaturalWidth() / 2, sprite.getNaturalHeight());
		if (id == 1) sprite.setXY(back.getNaturalWidth() / 2  - 22, back.getNaturalHeight() - 12);
		if (id == 2) sprite.setXY(back.getNaturalWidth() / 2  - 10, back.getNaturalHeight() - 12);
		if (id == 3) sprite.setXY(back.getNaturalWidth() / 2 - 4, back.getNaturalHeight() - 12);
		tank.addChild(new Entity().add(sprite));
		owner.addChild(tank);
		return back;
	}
	
}