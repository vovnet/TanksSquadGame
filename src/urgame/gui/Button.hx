package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.input.PointerEvent;
import flambe.util.Signal0;

/**
 * ...
 * @author Vladimir
 */
class Button extends Component {
	public var eventClick:Signal0 = new Signal0();
	
	public var normalSprite:ImageSprite;
	
	private var scaleX:Float = 1;
	private var scaleY:Float = 1;

	public function new(normal:String, ?pack:AssetPack) {
		var texture:Texture = (pack != null) ? pack.getTexture(normal) : G.pack.getTexture(normal);
		normalSprite = new ImageSprite(texture);
		normalSprite.setAnchor(normalSprite.getNaturalWidth() / 2, normalSprite.getNaturalHeight() / 2);
	}
	
	function onPointerOut(e:PointerEvent) {
		normalSprite.setScaleXY(scaleX, scaleY);
	}
	
	function onPointerIn(e:PointerEvent) {
		normalSprite.setScaleXY(scaleX * 1.02, scaleY * 1.02);
	}
	
	function onClick(e:PointerEvent) {
		eventClick.emit();
		G.pack.getSound("sounds/btn_click").play();
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.add(normalSprite);
		normalSprite.pointerDown.connect(onClick);
		
		normalSprite.pointerIn.connect(onPointerIn);
		normalSprite.pointerOut.connect(onPointerOut);
	}
	
	public function setXY(x:Float, y:Float) {
		normalSprite.setXY(x, y);
	}
	
	public function setScaleXY(sclX:Float, sclY:Float) {
		scaleX = sclX;
		scaleY = sclY;
		normalSprite.setScaleXY(scaleX, scaleY);
	}
	
	public function getWidth():Float {
		return normalSprite.getNaturalWidth();
	}
	
	public function getHeight():Float {
		return normalSprite.getNaturalHeight();
	}
	
}