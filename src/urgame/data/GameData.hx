package urgame.data;
import flambe.System;

/**
 * ...
 * @author Vladimir
 */
class GameData {
	public var priceTanks = [999, 15000];
	public var ranks = [
		new RankData("PRIVATE", "ranks/rank_1"),
		new RankData("CORPORAL", "ranks/rank_2"),
		new RankData("SERGEANT", "ranks/rank_3"),
		new RankData("OFFICER", "ranks/rank_4"),
		new RankData("CAPTAIN", "ranks/rank_5"),
		new RankData("BRIGADIER", "ranks/rank_6"),
		new RankData("COLONEL", "ranks/rank_7"),
		new RankData("MAJOR", "ranks/rank_8"),
		new RankData("LIEUTENANT", "ranks/rank_9"),
		new RankData("GENERAL", "ranks/rank_10")
	];
	public var rankId:Int;
	
	public var money:Float;
	public var tanks:Array<TankData>;
	public var level:Int;
	public var bossDamage:Float;
	public var bossHealth:Float;
	public var bossIndex:Int;
	public var maxHeroLevel:Int;
	public var backgroundId:Int;
	public var upgradePoints:Int;
	public var mission:Int;
	public var isTutorComplete:Bool;
	
	public var tanksKillKong:Int = 0;
	
	private var startHealth:Float;
	private var startDamage:Float;
	private var startCrit:Float;
	
	private var isExistSave:Bool = false;
	

	public function new() {
		init();
		load();
	}
	
	public function load() {
		if (!System.storage.get("isExistSave", false)) {
			return;
		}
		
		tanks[0] = TankData.fromObject(System.storage.get("hero_1"));
		tanks[1] = TankData.fromObject(System.storage.get("hero_2"));
		tanks[2] = TankData.fromObject(System.storage.get("hero_3"));
		rankId = System.storage.get("rankId");
		money = System.storage.get("money");
		startHealth = System.storage.get("startHealth");
		startDamage = System.storage.get("startDamage");
		startCrit = System.storage.get("startCrit");
		maxHeroLevel = System.storage.get("maxHeroLevel");
		bossIndex = System.storage.get("bossIndex");
		bossDamage = System.storage.get("bossDamage");
		bossHealth = System.storage.get("bossHealth");
		backgroundId = System.storage.get("backgroundId");
		level = System.storage.get("level");
		mission = System.storage.get("mission");
		isTutorComplete = System.storage.get("isTutorComplete");
	}
	
	public function save() {
		System.storage.set("hero_1", tanks[0].toObject());
		System.storage.set("hero_2", tanks[1].toObject());
		System.storage.set("hero_3", tanks[2].toObject());
		System.storage.set("rankId", rankId);
		System.storage.set("money", money);
		System.storage.set("startHealth", startHealth);
		System.storage.set("startDamage", startDamage);
		System.storage.set("startCrit", startCrit);
		System.storage.set("maxHeroLevel", maxHeroLevel);
		System.storage.set("bossIndex", bossIndex);
		System.storage.set("bossDamage", bossDamage);
		System.storage.set("bossHealth", bossHealth);
		System.storage.set("backgroundId", backgroundId);
		System.storage.set("level", level);
		System.storage.set("mission", mission);
		System.storage.set("isTutorComplete", isTutorComplete);
		
		isExistSave = true;
		System.storage.set("isExistSave", isExistSave);
		
		sendKong();
	}
	
	private function sendKong() {
		System.external.call("kongregate.stats.submit", ["Progress", tanksKillKong]);
		tanksKillKong = 0;
	}
	
	public function reset(startHealth:Float, startDamage:Float, startCrit:Float) {
		System.storage.clear();
		
		this.startHealth += startHealth;
		this.startDamage += startDamage;
		this.startCrit += startCrit;
		
		maxHeroLevel = Std.int(maxHeroLevel * 1.6);
		level = 1;
		money = 0;
		mission++;
		
		initConst();
	}
	
	private function init() {
		startHealth = 30;
		startDamage = 4;
		startCrit = 12;
		maxHeroLevel = 24;
		money = 0;
		mission = 1;
		isTutorComplete = false;
		
		rankId = 0;
		
		initConst();
	}
	
	private function initConst() {
		tanks = new Array<TankData>();
		tanks.push(new TankData(1, true, 0, startHealth, startDamage, startCrit));
		tanks.push(new TankData(2, false, 0, startHealth * 5, startDamage * 7, startCrit * 6));
		tanks.push(new TankData(3, false, 0, startHealth * 14, startDamage * 10, startCrit * 10));
		
		tanks[1].priceUpCrit *= 15;
		tanks[1].priceUpDamage *= 15;
		tanks[1].priceUpHealth *= 15;
		
		tanks[2].priceUpCrit *= 40;
		tanks[2].priceUpDamage *= 40;
		tanks[2].priceUpHealth *= 40;
		
		level = 1;
		bossIndex = 0;
		bossDamage = 30;
		bossHealth = 400;
		backgroundId = 0;
		upgradePoints = 0;
	}
	
}