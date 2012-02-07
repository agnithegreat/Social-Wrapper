package business.api {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class Wrapper extends EventDispatcher {
		
		public static const SOCIAL_VK: String = "vk";
		public static const SOCIAL_MM: String = "mm";
		public static const SOCIAL_OK: String = "ok";
		public static const SOCIAL_FB: String = "fb";
		public static const SOCIAL_VZ: String = "vz";
		
		public static const GET_USERS: String = "getUsers";
		public static const GET_FRIENDS: String = "getFriends";
		public static const GET_APP_FRIENDS: String = "getAppFriends";
		
		public static const APPLICATION_ADDED: String = "application_added";
		public static const SETTINGS_CHANGED: String = "settings_changed";
		public static const BALANCE_CHANGED: String = "balance_changed";
		public static const WALL_POST: String = "wall_post";
		public static const WINDOW_FOCUS: String = "window_focus";
		public static const MOUSE_LEAVE: String = "mouse_leave";
		
		public static function getWrapperClass($sn: String):Class {
			switch ($sn) {
				case SOCIAL_VK:
					return VKWrapper;
				case SOCIAL_MM:
					return MMWrapper;
				case SOCIAL_OK:
					return OKWrapper;
				case SOCIAL_FB:
					return FBWrapper;
				case SOCIAL_VZ:
					return VZWrapper;
			}
			return Wrapper;
		}
		
		protected var _stage: Sprite;
		
		protected var _flashVars : Object;
		public function get flashVars():Object {
			return _flashVars;
		}
		
		protected var _uid: String;
		public function get uid():String {
			return _uid;
		}
		
		protected var _name: String;
		public function get name():String {
			return _name;
		}
		
		protected var _opened_from: Object;
		public function get opened_from():Object {
			return _opened_from;
		}
		
		protected var _social: String;
		public function get social():String {
			return _social;
		}
		
		protected var _url: String;
		public function get url():String {
			return _url;
		}
		
		public function Wrapper($stage: Sprite, $flashVars: Object) {
			_stage = $stage;
			_flashVars = $flashVars;
		}
		
		public function init():void {
			
		}
		
		public function getMe():void {
			
		}
		
		public function getUsers($users: Array):void {
			
		}
		
		public function getFriends():void {
			
		}
		
		public function getAppFriends():void {
			
		}
		
		public function wallPost($data: Object):void {
			
		}
		
		public function inviteFriend($text: String = null):void {
			
		}
		
		public function showPayment($data: Object):void {
			
		}
		
		public function navigateToUrl($url: String, $window: String = "_blank"):void {
			if (!$url) {
				return;
			}
			var request: URLRequest = new URLRequest($url);
			navigateToURL(request, $window);
		}
		
		public function refresh($params: String):void {
			navigateToUrl(_url+$params, "_self");
		}
		
		public function navigateToProfile($user: SocialUser):void {
			navigateToUrl($user.profileUrl);
		}
		
		protected function parseUser($data: Object):Array {
			var user: SocialUser = new SocialUser();
			user.parseSocialUser($data, _social);
			return [user];
		}
		
		protected function parseUsers($data: Object):Array {
			var users : Array = [];
			for (var i : String in $data) {
				if (!($data[i] is String)) {
					var user: SocialUser = new SocialUser();
					user.parseSocialUser($data[i], _social);
					users.push(user);
				}
			}
			return users;
		}
	}
}
