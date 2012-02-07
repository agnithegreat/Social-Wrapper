package business.api {
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class SocialUser extends EventDispatcher {
		
		protected var _uid: String;
		public function get uid():String {
			return _uid;
		}
		
		protected var _first_name: String;
		public function get first_name():String {
			return _first_name;
		}
		
		protected var _last_name: String;
		public function get last_name():String {
			return _last_name;
		}
		
		protected var _nick: String;
		
		protected var _sex: int;
		public function get sex():int {
			return _sex;
		}
		
		protected var _photo: String;
		
		protected var _profileUrl: String;
		public function get profileUrl():String {
			return _profileUrl;
		}
		
		public function parseSocialUser($data: Object, $sn: String):void {
			_first_name = $data.first_name;
			_last_name = $data.last_name;
			switch ($sn) {
				case Wrapper.SOCIAL_VK:
					_uid = $data.uid;
					_sex = $data.sex%2;
					_photo = $data.photo;
					_profileUrl = "http://vk.com/id"+_uid;
					break;
				case Wrapper.SOCIAL_VZ:
					_uid = $data.uid;
					_sex = $data.sex%2;
					_photo = $data.photo;
					_profileUrl = "http://vk.com/id"+_uid;
					break;
				case Wrapper.SOCIAL_MM:
					_uid = $data.uid;
					_sex = $data.sex%2;
					_photo = $data.pic;
					_nick = $data.nick;
					_profileUrl = "http://my.mail.ru/mail/"+_nick;
					break;
				case Wrapper.SOCIAL_OK:
					_uid = $data.uid;
					_sex = $data.gender=="female" ? 1 : 0;
					_photo = $data.pic_1;
					_profileUrl = $data.profile_url;
					break;
				case Wrapper.SOCIAL_FB:
					_uid = $data.id;
					_sex = $data.gender=="female" ? 1 : 0;
					_photo = $data.picture;
					break;
			}
		}
		
		private var _photoLoader: Loader;
		private var _callbacks: Array = [];
		private var _loading: Boolean;
		
		private var _photoBMP: BitmapData;
		public function get photo():DisplayObject {
			if (!_photoBMP) {
				return null;
			}
			return new Bitmap(_photoBMP.clone());
		}
		public function get photo_loaded():Boolean {
			return Boolean(_photoBMP);
		}
		
		public function load($callback: Function):void {
			if (_photo && !_loading) {
				_loading = true;
				_callbacks.push($callback);
				
				_photoLoader = new Loader();
				_photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaded);
				_photoLoader.load(new URLRequest(_photo), new LoaderContext(true, ApplicationDomain.currentDomain));
			}
		}
		
		private function handleLoaded(e: Event):void {
			_photoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoaded);
			
			_photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleBytesComplete);
			_photoLoader.loadBytes(_photoLoader.contentLoaderInfo.bytes);
		}
 
		private function handleBytesComplete(e: Event):void {
			_photoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleBytesComplete);
			
			var source:	DisplayObject = _photoLoader.contentLoaderInfo.content as DisplayObject;
			_photoBMP = new BitmapData(source.width, source.height, true, 0x00000000);
			_photoBMP.draw(source);
			
			for (var i : int = 0; i < _callbacks.length; i++) {
				_callbacks[i](e);
			}
		}
	}
}
