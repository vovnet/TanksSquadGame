package urgame.gui;

import flambe.Component;
import flambe.Entity;
import flambe.animation.AnimatedFloat;
import flambe.display.ImageSprite;
import urgame.screens.GameScreen;
import urgame.units.enemies.EnemySpawner;

/**
 * ...
 * @author Vladimir
 */
class GameProgress extends Component {
	private var game:GameScreen;
	private var bar:ProgressBar;
	private var progress:AnimatedFloat = new AnimatedFloat(0);

	public function new(game:GameScreen, x:Float, y:Float) {
		this.game = game;
		
		var backLine:ImageSprite = new ImageSprite(G.pack.getTexture("gui/boss/boss_bar_back"));
		var frontLine:ImageSprite = new ImageSprite(G.pack.getTexture("gui/boss/boss_bar_front"));
		bar = new ProgressBar(backLine, frontLine, x, y, progress);
		
		
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(new Entity().add(bar));
		
		var skull:ImageSprite = new ImageSprite(G.pack.getTexture("gui/boss/boss"));
		skull.setXY(780, 12);
		owner.addChild(new Entity().add(skull));
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		progress._ = game.enemySpawner.getNumKillEnemies() / EnemySpawner.MAX_ENEMIES;
	}
	
}