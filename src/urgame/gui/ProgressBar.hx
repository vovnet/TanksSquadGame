package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.animation.AnimatedFloat;
import flambe.display.Sprite;
import flambe.math.Rectangle;

/**
 * ...
 * @author Vladimir
 */
class ProgressBar extends Component {
	private var container:Entity;
	private var backLine:Sprite;
	private var frontLine:Sprite;
	private var width:Float;
	private var x:Float;
	private var y:Float;
	private var percent:AnimatedFloat;

	public function new(backLine:Sprite, frontLine:Sprite, x:Float, y:Float, percent:AnimatedFloat) {
		this.backLine = backLine;
		this.frontLine = frontLine;
		this.x = x;
		this.y = y;
		this.percent = percent;
		backLine.centerAnchor();
		frontLine.centerAnchor();
		width = frontLine.getNaturalWidth();
	}
	
	override public function onStart() {
		super.onStart();
		container = new Entity().add(backLine);
		backLine.setXY(x, y);
		owner.addChild(container);
		container.addChild(new Entity().add(frontLine));
		frontLine.scissor = new Rectangle(0, 0, frontLine.getNaturalWidth(), frontLine.getNaturalHeight());
		frontLine.setXY(backLine.getNaturalWidth() / 2, backLine.getNaturalHeight() / 2);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		frontLine.scissor.width = percent._ * width;
	}
	
}