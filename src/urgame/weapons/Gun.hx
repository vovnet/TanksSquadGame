package urgame.weapons;

import flambe.Component;
import flambe.swf.MovieSprite;
import urgame.units.Unit;

/**
 * ...
 * @author Vladimir
 */
class Gun extends Component {
	/**
	 * Скорострельность пушки.
	 */
	public var fireRate:Float;
	
	/**
	 * Так как у юнита может быть более 1 пушки, и у каждой может быть своя величина урона,
	 * и со временем характеристики будут увеличиваться, то каждая пушка должна хранить урон
	 * в процентах. Задается при создании пушки.
	 */
	public var damagePercent:Float;
	
	private var elapsed:Float = 0;
	private var unit:Unit;
	private var fireAnimation:MovieSprite;
	private var sound:String;
	
	/**
	 * Реальный урон, который нужно инициализировать. Вычисляется по проценту.
	 */
	private var damage:Float;

	public function new(fireRate:Float, damagePercent:Float, ?sound:String) {
		this.fireRate = fireRate;
		this.damagePercent = damagePercent;
		this.sound = sound;
	}
	
	override public function onStart() {
		super.onStart();
		unit = owner.parent.get(Unit);
		fireAnimation = owner.get(MovieSprite);
		fireAnimation.looped.connect(onCompleteFire);
		hideFire();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		elapsed += dt;
		if (elapsed >= fireRate) {
			if (unit.fire(damage)) {
				showFire();
				elapsed = 0;
				G.pack.getSound(sound).play();
			}
		}
	}
	
	/**
	 * Инициализируем урон, который будет наноситься пушкой.
	 * @param	maxDamage Общий урон, который наносит юнит.
	 */
	public function init(maxDamage:Float) {
		damage = maxDamage * (damagePercent / 100);
	}
	
	function onCompleteFire() {
		hideFire();
	}
	
	private function showFire() {
		fireAnimation.paused = false;
		fireAnimation.visible = true;
	}
	
	private function hideFire() {
		fireAnimation.paused = true;
		fireAnimation.visible = false;
	}
	
}