package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.math.Rectangle;
import flambe.scene.Director;
import flambe.scene.Scene;
import urgame.screens.PreloaderScreen;

class Main {
	public static var container:Entity;
	
    private static function main () {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack) {
		container = new Entity();
		container.add(new FillSprite(0x000000, G.width, G.height));
		System.root.addChild(container);
        G.init();
		G.director = new Director();
		container.add(G.director);
		G.director.unwindToScene(new Entity().add(new Scene()).add(new PreloaderScreen(pack)));
		System.stage.resize.connect(onResize);
		onResize();
    }
	
	private static function onResize() {
		// iPhone 5 as target dimension
		var targetWidth = G.width; 
		var targetHeight = G.height;

		// Specifies that the entire application be scaled for the specified target area while maintaining the original aspect ratio.
		var scale = FMath.min(System.stage.width / targetWidth, System.stage.height / targetHeight);
		if (scale > 1) scale = 1; // You could choose to never scale up.

		// re-scale and center the sprite of the container to the middle of the screen.
		container.get(Sprite)
			.setScale(scale)
			.setXY((System.stage.width - targetWidth * scale) / 2, (System.stage.height - targetHeight * scale) / 2);

		// You can even mask so you cannot look outside of the container
		container.get(Sprite).scissor = new Rectangle(0, 0, targetWidth, targetHeight);
	}
}
