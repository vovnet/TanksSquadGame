package urgame.effects;

import flambe.Component;
import flambe.Entity;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.util.Pool;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class DamageField extends Component {
	private var game:GameScreen;
	private var poolDamage:Pool<Entity>;
	private var poolCoin:Pool<Entity>;
	private var poolCrit:Pool<Entity>;
	private var angArr = [-30, -20, -10, 0, 10, 20, 30];
	
	public function new(game:GameScreen) {
		this.game = game;
		poolDamage = new Pool(creatorDamage);
		poolDamage.setSize(20);
		
		poolCoin = new Pool(creatorAwardCoin);
		poolCoin.setSize(20);
		
		poolCrit = new Pool(creatorCrit);
		poolCrit.setSize(20);
	}
	
	public function showDamage(txt:String, x:Float, y:Float) {
		var ent:Entity = poolDamage.take();
		var text:TextSprite = ent.get(TextSprite);
		if (text != null) {
			text.text = txt;
			text.setXY(x, y);
		}
		var field:EffectField = ent.get(EffectField);
		field.init(poolDamage);
		game.coinLayer.addChild(ent);
	}
	
	public function showCoin(txt:String, x:Float, y:Float) {
		var ent:Entity = poolCoin.take();
		var text:TextSprite = ent.get(TextSprite);
		if (text != null) {
			text.text = txt;
			text.setXY(x, y);
		}
		var field:EffectField = ent.get(EffectField);
		field.init(poolCoin);
		game.coinLayer.addChild(ent);
	}
	
	public function showCrit(txt:String, x:Float, y:Float) {
		var ent:Entity = poolCrit.take();
		
		var img:Sprite = ent.get(Sprite);
		if (img != null) {
			img.setXY(x, y);
			img.setRotation(Random.fromArray(angArr));			
		}
		var text:TextSprite = ent.getFromChildren(TextSprite);
		if (text != null) {
			text.text = txt;
		}
		var field:EffectCrit = ent.get(EffectCrit);
		field.init(poolCrit);
		game.coinLayer.addChild(ent);
	}
	
	private function creatorCrit():Entity {
		var ent:Entity = new Entity();
		var back:ImageSprite = new ImageSprite(G.pack.getTexture("effects/crit"));
		back.centerAnchor();
		ent.add(back);
		var text:TextSprite = new TextSprite(new Font(G.pack, "fonts/crit_font"));
		text.setAlign(TextAlign.Center);
		text.setXY(back.getNaturalWidth() / 2, 20);
		ent.addChild(new Entity().add(text));
		ent.add(new EffectCrit());
		
		return ent;
	}
	
	private function creatorDamage():Entity {
		var ent:Entity = new Entity();
		var text:TextSprite = new TextSprite(new Font(G.pack, "fonts/damage_font"));
		text.setAlign(TextAlign.Center);
		ent.add(text);
		ent.add(new EffectField());
		return ent;
	}
	
	private function creatorAwardCoin():Entity {
		var ent:Entity = new Entity();
		var text:TextSprite = new TextSprite(new Font(G.pack, "fonts/award_font"));
		text.setAlign(TextAlign.Center);
		ent.add(text);
		ent.add(new EffectField());
		return ent;
	}
	
}