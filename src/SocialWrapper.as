package {
	import flash.system.ApplicationDomain;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.net.URLRequest;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.system.Security;
	import flash.events.Event;
	import flash.display.Loader;
	import business.api.Wrapper;
	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class SocialWrapper extends Sprite {
		
		protected var _wrapper: Wrapper;
		
		protected var _applicationContainer: Sprite;
		
		protected var _flashVars: Object;
		
		public function SocialWrapper() {
			if (stage) {
				handleAddedToStage(null);
			} else {
				addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}
		
		private function handleAddedToStage(e: Event) : void {
			Security.allowDomain("*");
			stage.dispatchEvent(new Event(Event.DEACTIVATE));
			stage.dispatchEvent(new Event(Event.ACTIVATE));
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_applicationContainer = new Sprite();
			stage.addChild(_applicationContainer);
		}
		
		public function init($app_url: String, $sn: String, $flash_vars: Object):void {
			_flashVars = $flash_vars;
			
			var WrapperClass: Class = Wrapper.getWrapperClass($sn);
			_wrapper = new WrapperClass(this, _flashVars);
			
			var req : URLRequest = new URLRequest($app_url+"?_"+new Date().time);
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleInit);
			var security: SecurityDomain = SecurityDomain.currentDomain;
			var loaderContext: LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, security);
			loader.load(req, loaderContext);
		}

		protected function handleInit(e : Event) : void {
			var loaderInfo: LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, handleInit);
			var applicationDomain: ApplicationDomain = loaderInfo.applicationDomain;
			var ApplicationClass: Class = applicationDomain.getDefinition("Application") as Class;
			var application: Object = new ApplicationClass();
			_applicationContainer.addChild(application as Sprite);
			application.init(_flashVars, _wrapper);
		}
	}
}
