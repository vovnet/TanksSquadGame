package urgame.gui;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.TextSprite;

/**
 * ...
 * @author Vladimir
 */
class TextButton extends Button {
	private var text:TextSprite;

	public function new(normal:String, font:String = "", txt:String = "") {
		super(normal);
		
		text = new TextSprite(new Font(G.pack, font), txt);
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(new Entity().add(text));
		updateTextField();
	}
	
	public function setText(txt:String) {
		text.text = txt;
		updateTextField();
	}
	
	private function updateTextField() {
		text.setAnchor(text.getNaturalWidth() / 2, text.getNaturalHeight() / 2);
		text.setXY(normalSprite.getNaturalWidth() / 2, normalSprite.getNaturalHeight() / 2);
	}
	
}