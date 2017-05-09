package urgame.data;

/**
 * ...
 * @author Vladimir
 */
class TankData {
	public var id:Int = 0;
	public var isOpen:Bool = false;
	public var level:Int = 0;
	public var health:Float = 100;
	public var currentHealth:Float = 0;
	public var damage:Float = 10;
	public var crit:Float = 150;
	
	// const data
	public var img:String;
	public var x:Float;
	public var y:Float;
	
	public var priceUpHealth:Float = 10;
	public var priceUpDamage:Float = 10;
	public var priceUpCrit:Float = 10;
	
	public var lvlHealth:Int = 1;
	public var lvlDamage:Int = 1;
	public var lvlCrit:Int = 1;

	public function new(?id:Int, ?isOpen:Bool, ?level:Int, ?health:Float, ?damage:Float, ?crit:Float) {
		this.id = id;
		this.isOpen = isOpen;
		this.level = level;
		this.health = health;
		this.damage = damage;
		this.crit = crit;
		TankData.addConstData(this);
	}
	
	public function toObject():Dynamic {
		return { "id":id, "isOpen":isOpen, "level":level, "health":health, "damage":damage, "crit":crit, "priceUpHealth":priceUpHealth,
			"priceUpDamage":priceUpDamage, "priceUpCrit":priceUpCrit, "lvlHealth":lvlHealth, "lvlDamage":lvlDamage, "lvlCrit":lvlCrit
		};
	}
	
	static public function fromObject(obj:Dynamic):TankData {
		var data:TankData = new TankData(obj.id, obj.isOpen, obj.level, obj.health, obj.damage, obj.crit);
		data.priceUpHealth = obj.priceUpHealth;
		data.priceUpDamage = obj.priceUpDamage;
		data.priceUpCrit = obj.priceUpCrit;
		data.lvlHealth = obj.lvlHealth;
		data.lvlDamage = obj.lvlDamage;
		data.lvlCrit = obj.lvlCrit;
		data.health = obj.health;
		return TankData.addConstData(data);
	}
	
	static private function addConstData(data:TankData):TankData {
		switch (data.id) {
			case 1:
				data.img = "tanks/hero_1";
				data.x = 350;
				data.y = 320;
			case 2:
				data.img = "tanks/hero_2";
				data.x = 140;
				data.y = 230;
			case 3:
				data.img = "tanks/hero_3";
				data.x = 180;
				data.y = 450;
		}
		return data;
	}
	
}