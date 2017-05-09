package urgame.units.enemies;

import flambe.Component;
import flambe.Entity;
import flambe.animation.Ease;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.math.Point;
import flambe.script.AnimateBy;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import urgame.gui.ProgressBar;
import urgame.screens.GameScreen;
import urgame.units.Unit;


/**
 * ...
 * @author Vladimir
 */
class EnemySpawner extends Component {
	public static inline var MAX_ENEMIES:Int = 50;
	
	public var game:GameScreen;
	public var tanks:Array<Entity>;
	public var bosses:Array<Entity>;
	public var positions:Array<EnemyPositions> = [
		new EnemyPositions(1080, 240, false), 
		new EnemyPositions(800, 120, false), 
		new EnemyPositions(810, 330, false)
	];
	
	private var enemiesCounter:Int = 0;

	public function new(game:GameScreen) {
		this.game = game;
	}
	
	override public function onStart() {
		super.onStart();
		initEnemies();
		initBosses();
		spawn();
		//spawnBoss();
	}
	
	public function getNumKillEnemies():Float {
		return enemiesCounter;
	}
	
	private function initEnemies() {
		tanks = new Array<Entity>();
		var enemy:Entity;
		for (i in 1...12) {
			enemy = EnemiesFactory.createEnemy(i);
			var en = enemy.get(Unit);
			en.eventKill.connect(onKillEnemy);
			tanks.push(enemy);
		}
	}
	
	private function initBosses() {
		bosses = new Array<Entity>();
		var boss:Entity;
		for (i in 1...6) {
			boss = EnemiesFactory.createBoss(i);
			bosses.push(boss);
			var u:Unit = boss.get(Unit);
			u.eventKill.connect(onKillBoss);
		}
	}
	
	private function spawn() {
		for (i in positions) {
			if (!i.isBusy) {
				var enemy:Entity = Random.fromArray(tanks);
				tanks.remove(enemy);
				var en:Enemy = enemy.get(Enemy);
				en.init(G.gameData.bossHealth * 0.1, G.gameData.bossDamage * 0.6, game, i);
				var sprite:Sprite = enemy.get(Sprite);
				sprite.x.animate(G.width + sprite.getNaturalWidth(), i.x, 0.4, Ease.backOut);
				sprite.y._ = i.y;
				i.isBusy = true;
				game.enemies.push(enemy);
				game.enemyLayer.addChild(enemy);
				enemiesCounter++;
				//break;
			}
		}
	}
	
	private function spawnBoss() {
		for (i in positions) {
			if (i.isBusy) return;
		}
		var boss = bosses[G.gameData.bossIndex];
		var enemy:Enemy = boss.get(Enemy);
		enemy.init(G.gameData.bossHealth, G.gameData.bossDamage, game, new EnemyPositions(700, 300, false));
		var sprite:Sprite = boss.get(Sprite);
		sprite.x.animate(G.width + sprite.getNaturalWidth(), 1000, 0.4, Ease.backOut);
		sprite.y._ = 200;
		game.enemies.push(boss);
		game.enemyLayer.addChild(boss);
	}
	
	function onKillEnemy(enemy:Entity) {
		enemiesCounter++;
		game.enemyLayer.removeChild(enemy);
		tanks.push(enemy);
		var enemy:Enemy = enemy.get(Enemy);
		enemy.positions.isBusy = false;
		var script:Script = new Script();
		owner.add(script);
		if (enemiesCounter >= MAX_ENEMIES) {
			script.run(new Sequence([new Delay(1), new CallFunction(spawnBoss)]));
		} else {
			script.run(new Sequence([new Delay(1), new CallFunction(spawn)]));
		}	
	}
	
	function onKillBoss(enemy:Entity) {
		enemiesCounter = 0;
		game.enemyLayer.removeChild(enemy);
		G.gameData.bossIndex = (G.gameData.bossIndex + 1) % bosses.length;
		G.gameData.bossDamage *= 1.5;
		G.gameData.bossHealth *= 1.5;
		G.gameData.level++;
		
		
		hide();
	}
	
	public function hide() {
		game.fadeLayer.addChild(game.fade.owner);
		game.fade.setAlpha(0);
		game.fade.alpha.changed.connect(onChangeFade);
		var script:Script = new Script();
		script.run(new Sequence([
			new Delay(1), 
			new AnimateTo(game.fade.alpha, 1, 0.6) 
		]));
		owner.add(script);
	}
	
	function onChangeFade(curr:Float, prev:Float) {
		if (curr == 1 && prev < curr) {
			show();
		}
		
		if (curr  == 0 && prev > curr) {
			game.fadeLayer.removeChild(game.fade.owner);
			spawn();
		}
	}
	
	function show() {
		game.backgroundManager.changeBack();
		
		var script:Script = new Script();
		script.run(new Sequence([
			new Delay(1), 
			new AnimateTo(game.fade.alpha, 0, 0.6) 
		]));
		owner.add(script);
		G.gameData.save();
	}
	
}