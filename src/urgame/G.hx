package urgame;
import flambe.asset.AssetPack;
import flambe.scene.Director;
import urgame.data.GameData;

/**
 * ...
 * @author Vladimir
 */
class G {
	static public var width:Int = 1136;
	static public var height:Int = 640;
	static public var gameData:GameData;
	static public var director:Director;
	static public var pack:AssetPack;
	static public var isOnSound:Bool = true;
	static public var androidLink:String = "https://play.google.com/store/apps/details?id=air.com.blepgames.tanks";

	public function new() {}
	
	static public function init():Void {
		G.gameData = new GameData();
		G.gameData.load();
	}
}