package {
	import flash.net.navigateToURL;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class SocialWrapperWithBanner extends SocialWrapper {
		
		private var _bannerContainer: Sprite;
		
		private var _banner_url: String;
		private var _target_url: String;
		
		public function loadBanner($banner_url: String, $position: int, $target_url: String):void {
			_banner_url = $banner_url;
			_target_url = $target_url;
			
			_bannerContainer = new Sprite();
			_bannerContainer.buttonMode = true;
			_bannerContainer.addEventListener(MouseEvent.CLICK, handleClick);
			_bannerContainer.y = $position;
			stage.addChild(_bannerContainer);
			
			var loader: Loader = new Loader();
			_bannerContainer.addChild(loader);
			var loaderContext: LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			loader.load(new URLRequest(_banner_url), loaderContext);
		}

		private function handleClick(e : MouseEvent) : void {
			navigateToURL(new URLRequest(_target_url));
		}
	}
}
