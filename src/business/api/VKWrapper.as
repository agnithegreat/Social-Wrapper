package business.api {
	import flash.net.URLRequest;
	import business.tasks.APITask;
	import business.tasks.WallPostTask;
	import business.tasks.GetVkUsersTask;
	import business.event.WrapperEvent;
	import flash.display.Sprite;
	import vk.APIConnection;

	/**
	 * @author virich
	 */
	public class VKWrapper extends Wrapper {
		
		public static const GET_PROFILES: String = "getProfiles";
		
		public static const SHOW_INVITE_BOX: String = "showInviteBox";
		public static const SHOW_SETTINGS_BOX: String = "showSettingsBox";
		public static const SHOW_PAYMENT_BOX: String = "showPaymentBox";
		public static const SAVE_WALL_POST: String = "saveWallPost";
		
		public static const GET_PHOTO_UPLOAD_SERVER: String = "wall.getPhotoUploadServer";
		public static const WALL_SAVE_POST: String = "wall.savePost";
		
		private var _external: Object;
		
		public function VKWrapper($stage: Sprite, $flashVars: Object) {
			super($stage, $flashVars);

			var wrapper: Object = Object($stage.parent.parent);
			_external = wrapper.external ? wrapper.external : new APIConnection(_flashVars);
			
			if (wrapper.external) {
				wrapper.addEventListener("onApplicationAdded", handleApplicationAdded);
				wrapper.addEventListener("onSettingsChanged", handleSettingsChanged);
				wrapper.addEventListener("onBalanceChanged", handleBalanceChanged);
				wrapper.addEventListener("onWallPostSave", handleWallPostSave);
				wrapper.addEventListener("onWallPostCancel", handleWallPostCancel);
				wrapper.addEventListener("onWindowBlur", handleWindowBlur);
				wrapper.addEventListener("onWindowFocus", handleWindowFocus);
				wrapper.addEventListener("onMouseLeave", handleMouseLeave);
			}
		}
		
		override public function init():void {
			_uid = _flashVars["viewer_id"];
			
			_social = SOCIAL_VK;
			
			_url = "http://vkontakte.ru/app"+_flashVars["api_id"];
			
			if (_flashVars["post_id"]) {
				_opened_from = {};
				_opened_from.post_id = _flashVars["post_id"];
				_opened_from.full = _flashVars["referrer"]!="wall_view_inline";
				_opened_from.user_id = _flashVars["poster_id"];
			}
		}
		
		override public function getMe():void {
			var task: APITask = new APITask(GET_PROFILES, {uids: uid, fields: "photo,sex"}, APITask.API, _external, handleLoadUsers);
			task.run();
		}
		
		override public function getUsers($users: Array):void {
			var task: APITask = new APITask(GET_PROFILES, {uids: $users.join(","), fields: "photo,sex"}, APITask.API, _external, handleLoadUsers);
			task.run();
		}
		
		override public function getFriends():void {
			var task: GetVkUsersTask = new GetVkUsersTask(_external, null, GET_FRIENDS, handleLoadFriends);
			task.run();
		}
		
		override public function getAppFriends():void {
			var task: GetVkUsersTask = new GetVkUsersTask(_external, null, GET_APP_FRIENDS, handleLoadAppFriends);
			task.run();
		}
		
		override public function wallPost($data: Object):void {
			var task: WallPostTask = new WallPostTask(_external, $data);
			task.run();
		}
		
		override public function inviteFriend($text: String = null):void {
			var task: APITask = new APITask(SHOW_INVITE_BOX, {}, APITask.CALL_METHOD, _external);
			task.run();
		}
		
		override public function showPayment($data: Object):void {
			var task: APITask = new APITask(SHOW_PAYMENT_BOX, $data, APITask.CALL_METHOD, _external);
			task.run();
		}
		
		override public function navigateToUrl($url: String, $window: String = "_blank"):void {
			var request: URLRequest = new URLRequest($url);
			_external.navigateToURL(request, $window);
		}
		

		private function handleLoadUsers($data: Object) : void {
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_USERS, parseUsers($data)));
		}
		
		private function handleLoadFriends($data: Object) : void {
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_FRIENDS, parseUsers($data)));
		}
		
		private function handleLoadAppFriends($data: Object) : void {
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_APP_FRIENDS, parseUsers($data)));
		}
		
		
		
		
		private function handleApplicationAdded($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, APPLICATION_ADDED, null, false));
		}
		
		private function handleSettingsChanged($settings: int):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, SETTINGS_CHANGED, $settings, false));
		}
		
		private function handleBalanceChanged($balance: int):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, BALANCE_CHANGED, $balance, false));
		}
		
		private function handleWallPostSave($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, WALL_POST, true, false));
		}
		
		private function handleWallPostCancel($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, WALL_POST, false, false));
		}
		
		private function handleWindowBlur($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, WINDOW_FOCUS, false, false));
		}
		
		private function handleWindowFocus($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, WINDOW_FOCUS, true, false));
		}
		
		private function handleMouseLeave($data: Object = null):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, MOUSE_LEAVE, null, false));
		}
	}
}
