package urgame.units.heroes;

import flambe.Component;
import urgame.data.TankData;

/**
 * ...
 * @author Vladimir
 */
class Data extends Component {
	public var data:TankData;
	
	private var damage:Float;
	private var crit:Float;
	
	public function new(data:TankData) {
		this.data = data;
		data.currentHealth = data.health;
		this.damage = 0;
		this.crit = 0;
	}
	
	public function init() {
		data.currentHealth = data.health;
	}
	
	public function getDamage():Float {
		return damage + data.damage;
	}
	
	public function setDamage(damage:Float) {
		this.damage = damage;
	}
	
	public function getCrit():Float {
		return crit + data.crit;
	}
	
	public function setCrit(crit:Float) {
		this.crit = crit;
	}
	
	public function getSumHealth():Float {
		return data.health;
	}
	
	public function getCurrentHealth():Float {
		return data.currentHealth;
	}
	
	public function hurt(damage:Float) {
		data.currentHealth -= damage;
	}
	
}