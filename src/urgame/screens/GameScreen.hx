package urgame.screens;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.scene.Scene;
import flambe.swf.Flipbook;
import flambe.swf.Library;
import flambe.swf.MovieSprite;
import flambe.util.Pool;
import urgame.data.TankData;
import urgame.effects.BigExplosion;
import urgame.effects.PoolableEffect;
import urgame.effects.DamageField;
import urgame.effects.EffectField;
import urgame.effects.EffectsFactory;
import urgame.gui.AreaLabel;
import urgame.gui.GameProgress;
import urgame.gui.MainPanel;
import urgame.gui.ProgressBar;
import urgame.ranks.AllRanksWindow;
import urgame.ranks.RankIcon;
import urgame.ranks.UpgradeRank;
import urgame.ranks.YesNoRanks;
import urgame.tutorial.TutorialManager;
import urgame.units.Scraps;
import urgame.units.Unit;
import urgame.units.enemies.EnemySpawner;
import urgame.units.heroes.Data;
import urgame.units.heroes.HeroAI;
import urgame.units.heroes.HeroesFactory;
import urgame.units.skills.FieldSkill;
import urgame.units.skills.PoolableAnimation;
import urgame.units.skills.RepairSkill;
import urgame.units.skills.RocketSkill;

/**
 * ...
 * @author Vladimir
 */
class GameScreen extends Component {
	public static var instance:GameScreen;
	
	public var backLayer:Entity;
	public var gameLayer:Entity;
	public var coinLayer:Entity;
	public var enemyLayer:Entity;
	public var rocketLayer:Entity;
	public var scrapLayer:Entity;
	public var rankLayer:Entity;
	public var guiLayer:Entity;
	public var tutorialLayer:Entity;
	public var popLayer:Entity;
	public var damageLayer:Entity;
	public var enemies:Array<Entity>;
	public var heroes:Array<Entity>;
	public var enemySpawner:EnemySpawner;
	public var backgroundManager:BackgroundGame;
	public var fadeLayer:Entity;
	public var fade:FillSprite;
	public var isAngar:Bool = false;
	public var textEffects:DamageField;
	
	public var poolRepairSkill:Pool<Entity>;
	public var poolFieldSkill:Pool<Entity>;
	public var smallScraps:Pool<Entity>;
	private var bigScrap:ImageSprite;
	private var bigExplostion:Entity;
	
	private var rocketSkill:RocketSkill;
	private var allRanksPop:AllRanksWindow;
	private var yesNoRanksPop:YesNoRanks;
	private var upgRank:UpgradeRank;
	private var progressPanel:GameProgress;
	
	private var clickEffectPool:Pool<Entity>;

	public function new() {
		instance = this;
		
		poolRepairSkill = new Pool<Entity>(fillRepairPool).setSize(3);
		poolFieldSkill = new Pool<Entity>(fillFieldPool).setSize(3);
		clickEffectPool = new Pool<Entity>(fillClickEffectPool).setSize(10);
		
		rocketSkill = new RocketSkill(this);
		gameLayer = new Entity();
		backLayer = new Entity();
		rocketLayer = new Entity();
		guiLayer = new Entity();
		popLayer = new Entity();
		fadeLayer = new Entity();
		damageLayer = new Entity();
		scrapLayer = new Entity();
		rankLayer = new Entity();
		tutorialLayer = new Entity();
		enemyLayer = new Entity();
		coinLayer = new Entity();
		heroes = new Array<Entity>();
		enemies = new Array<Entity>();
		enemySpawner = new EnemySpawner(this);
		textEffects = new DamageField(this);
		coinLayer.addChild(new Entity().add(textEffects));
		
		var imgBackLeft:ImageSprite = new ImageSprite(G.pack.getTexture("backs/back_1_left"));
		var imgBackRight:ImageSprite = new ImageSprite(G.pack.getTexture("backs/back_1_right"));
		imgBackRight.setXY(imgBackLeft.getNaturalWidth(), 0);
		backgroundManager = new BackgroundGame();
		backLayer.addChild(new Entity().add(backgroundManager));
		
		fade = new FillSprite(0x000000, G.width, G.height);
		new Entity().add(fade);
		
		allRanksPop = new AllRanksWindow(this);
		new Entity().add(allRanksPop);
		
		yesNoRanksPop = new YesNoRanks(this);
		new Entity().add(yesNoRanksPop);
		
		upgRank = new UpgradeRank(this);
		new Entity().add(upgRank);
		
		progressPanel = new GameProgress(this, G.width / 2, 60);
		new Entity().add(progressPanel);
		
		smallScraps = new Pool<Entity>(fillSmallScrapsPool);
		bigScrap = new ImageSprite(G.pack.getTexture("tanks/scrap_big"));
		bigScrap.alpha.changed.connect(onChangeBigScrap);
		new Entity().add(bigScrap);
	}
	
	public function showSmallExplosion(x:Float, y:Float) {
		var explosion:Entity = rocketSkill.poolExplotions.take();
		var anim:PoolableAnimation = explosion.get(PoolableAnimation);
		rocketLayer.addChild(explosion);
		anim.init(x, y);
		G.pack.getSound("sounds/explosion").play();
	}
	
	public function showBigExplostion(x:Float, y:Float) {
		var movie = bigExplostion.get(MovieSprite);
		movie.setXY(x, y);
		rocketLayer.addChild(bigExplostion);
		G.pack.getSound("sounds/explosion").play();
	}
	
	override public function onStart() {
		super.onStart();
		owner.addChild(gameLayer);
		gameLayer.addChild(backLayer);
		gameLayer.addChild(scrapLayer);
		gameLayer.addChild(enemyLayer);
		gameLayer.addChild(progressPanel.owner);
		gameLayer.addChild(rocketLayer);
		gameLayer.addChild(damageLayer);
		gameLayer.add(enemySpawner);
		gameLayer.addChild(coinLayer);
		gameLayer.addChild(rankLayer);
		owner.addChild(guiLayer);
		owner.addChild(popLayer);
		owner.addChild(tutorialLayer);
		owner.addChild(fadeLayer);
		
		gameLayer.addChild(new Entity().add(new AreaLabel()));
		
		if (!G.gameData.isTutorComplete) {
			tutorialLayer.add(new TutorialManager());
		}
		
		for (i in G.gameData.tanks) {
			if (i.isOpen) {
				var tank:Entity = HeroesFactory.makeHero(i, this);
				gameLayer.addChild(tank);
				heroes.push(tank);
			}
		}
		
		System.pointer.down.connect(onClick);
		
		guiLayer.addChild(new Entity().add(new MainPanel(0, 488, this)));
		
		var rank:RankIcon = new RankIcon();
		rankLayer.addChild(new Entity().add(rank));
		rank.setXY(80, 30);
		rank.eventClick.connect(onClickRankIcon);
		
		bigExplostion = new Entity().add(new BigExplosion());
		
		// TODO: del keyboard 
		//System.keyboard.down.connect(onKey);
	}
	
	
	
	public function repairSkillOn() {
		for (i in heroes) {
			var data:Data = i.get(Data);
			var unit:HeroAI = i.get(HeroAI);
			var skillEnt:Entity = poolRepairSkill.take();
			var skill:RepairSkill = skillEnt.get(RepairSkill);
			skill.init(data.data, unit, this);
			var tankEnt:Entity = i.firstChild.firstChild;
			var shadow:ImageSprite = tankEnt.get(ImageSprite);
			var movieSkill:MovieSprite = skillEnt.get(MovieSprite);
			var x:Float = 0;
			var y:Float = 0;
			switch (data.data.id) {
				case 1:
					x = 0;
					y = -74;
				case 2:
					x = -36;
					y = -86;
				case 3:
					x = -36;
					y = -76;
			}
			movieSkill.setXY(x, y);
			
			tankEnt.addChild(skillEnt);
		}
	}
	
	public function fieldSkillOn() {
		for (i in heroes) {
			var data:Data = i.get(Data);
			var unit:HeroAI = i.get(HeroAI);
			var skillEnt:Entity = poolFieldSkill.take();
			var skill:FieldSkill = skillEnt.get(FieldSkill);
			skill.init(unit, this);
			var tankEnt:Entity = i.firstChild.firstChild;
			var shadow:ImageSprite = tankEnt.get(ImageSprite);
			var movieSkill:MovieSprite = skillEnt.get(MovieSprite);
			var x:Float = 0;
			var y:Float = 0;
			switch (data.data.id) {
				case 1:
					x = 0;
					y = -54;
				case 2:
					x = -36;
					y = -66;
				case 3:
					x = -36;
					y = -56;
			}
			movieSkill.setXY(x, y);
			
			tankEnt.addChild(skillEnt);
		}
	}
	
	public function showYesNoRanksPop() {
		popLayer.addChild(yesNoRanksPop.owner);
	}
	
	public function showUpgradeRankPop() {
		popLayer.addChild(upgRank.owner);
	}
	
	public function rocketSkillOn() {
		rocketLayer.add(rocketSkill);
	}
	
	public function showSmallScrap(x:Float, y:Float) {
		var scrap:Scraps = smallScraps.take().get(Scraps);
		scrap.init(x, y);
		scrapLayer.addChild(scrap.owner);
	}
	
	public function showBigScrap(x:Float, y:Float) {
		bigScrap.setXY(x, y);
		bigScrap.setAlpha(1);
		bigScrap.alpha.animate(1, 0, 1);
		scrapLayer.addChild(bigScrap.owner);
	}
	
	function onKey(e:KeyboardEvent) {
		System.storage.clear();
	}
	
	
	function onClick(e:PointerEvent) {
		
	}
	
	public function showClickEffect(x:Float, y:Float, width:Float, height:Float) {
		var ent = clickEffectPool.take();
		var movie:MovieSprite = ent.get(MovieSprite);
		movie.centerAnchor();
		movie.disablePointer();
		movie.setXY(Random.float(x - width, x - width / 2),Random.float(y - height / 2, y + height / 2));
		movie.speed._ = 5;
		movie.setScale(0.5);
		var effect:PoolableEffect = ent.get(PoolableEffect);
		effect.init(clickEffectPool);
		damageLayer.addChild(ent);
	}
	
	private function fillRepairPool():Entity {
		var ent:Entity = new Entity()
			.add(EffectsFactory.createEffect("repairSkill"))
			.add(new RepairSkill());
		return ent;
	}
	
	private function fillFieldPool():Entity {
		return new Entity()
			.add(EffectsFactory.createEffect("fieldSkill"))
			.add(new FieldSkill());
	}
	
	function fillClickEffectPool():Entity {
		return new Entity()
			.add(EffectsFactory.createEffect("click").centerAnchor())
			.add(new PoolableEffect());
	}
	
	function onClickRankIcon() {
		showAllRanks();
	}
	
	private function showAllRanks() {
		popLayer.addChild(allRanksPop.owner);
	}
	
	function fillSmallScrapsPool():Entity {
		return new Entity()
			.add(new ImageSprite(G.pack.getTexture("tanks/scrap_small")))
			.add(new Scraps(this));		
	}
	
	function onChangeBigScrap(currentVal:Float, oldVal:Float) {
		if (currentVal <= 0 && currentVal < oldVal) {
			scrapLayer.removeChild(bigScrap.owner);
		}
	}
	
}