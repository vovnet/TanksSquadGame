package urgame.screens;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.animation.AnimatedFloat;
import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.ImageSprite;
import flambe.scene.Scene;
import flambe.scene.SlideTransition;
import flambe.util.Promise;
import urgame.gui.Button;
import urgame.gui.ProgressBar;

/**
 * ...
 * @author Vladimir
 */
class PreloaderScreen extends Component {
	private var bootstrapPack:AssetPack;
	private var loader:Promise<AssetPack>;
	private var bar:ProgressBar;
	private var progress:AnimatedFloat = new AnimatedFloat(0);
	private var loadingImg:ImageSprite;
	private var tank:ImageSprite;

	public function new(pack:AssetPack) {
		bootstrapPack = pack;
		var manifest = Manifest.fromAssets("game");
		loader = System.loadAssetPack(manifest);
		loader.get(onLoad);
		loader.progressChanged.connect(onProgress);
		
		loadingImg = new ImageSprite(bootstrapPack.getTexture("loading_text"));
		loadingImg.setAnchor(loadingImg.getNaturalWidth() / 2, 0);
		loadingImg.setXY(G.width / 2, 140);
		
		var backLine:ImageSprite = new ImageSprite(bootstrapPack.getTexture("bar_back"));
		var frontLine:ImageSprite = new ImageSprite(bootstrapPack.getTexture("bar_front"));
		bar = new ProgressBar(backLine, frontLine, G.width / 2, G.height / 2, progress);
		
		tank = new ImageSprite(bootstrapPack.getTexture("hero_1"));
		tank.centerAnchor();
		tank.setXY(G.width / 2, 450);
		
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(new Entity().add(loadingImg));
		owner.addChild(new Entity().add(bar));
		owner.addChild(new Entity().add(tank));
	}
	
	function onProgress() {
		progress._ = loader.progress / loader.total;
	}
	
	function onLoad(pack:AssetPack) {
		/*if (!Sitelock.checkSitelock()) {
			return;
		}*/
		G.pack = pack;
		owner.removeChild(bar.owner);
		owner.removeChild(loadingImg.owner);
		owner.removeChild(tank.owner);
		
		var btn:Button = new Button("main_screen/play_button");
		btn.setXY(G.width / 2, G.height / 2);
		btn.eventClick.connect(onClickPlay);
		owner.addChild(new Entity().add(btn));
		btn.normalSprite.scaleX.animate(0, 1, 0.4, Ease.backOut);
		btn.normalSprite.scaleY.animate(0, 1, 0.4, Ease.backOut);
	}
	
	function onClickPlay() {
		bootstrapPack.getSound("empty").play();
		var trans:SlideTransition = new SlideTransition(0.4).down();
		G.director.unwindToScene(new Entity().add(new Scene()).add(new MenuScreen()), trans);
	}
	
	
}