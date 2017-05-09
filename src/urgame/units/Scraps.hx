package urgame.units;

import flambe.Component;
import flambe.display.ImageSprite;
import urgame.screens.GameScreen;

/**
 * ...
 * @author Vladimir
 */
class Scraps extends Component {
	private var game:GameScreen;
	private var scrap:ImageSprite;

	public function new(game:GameScreen) {
		this.game = game;
	}
	
	public function init(x:Float, y:Float) {
		scrap.setXY(x, y);
		scrap.setAlpha(0);
		scrap.alpha.animate(1, 0, 1);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		scrap = owner.get(ImageSprite);
		scrap.alpha.changed.connect(onChangeScrapSmall);
	}
	
	function onChangeScrapSmall(currentVal:Float, oldVal:Float) {
		if (currentVal <= 0 && currentVal < oldVal) {
			game.smallScraps.put(owner);
			game.scrapLayer.removeChild(owner);
		}
	}
	
}