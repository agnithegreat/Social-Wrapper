package business.api {
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import business.tasks.GetOkUsersTask;
	import business.event.WrapperEvent;
	import api.com.odnoklassniki.sdk.stream.Stream;
	import com.api.forticom.ApiCallbackEvent;
	import com.api.forticom.ForticomAPI;
	import api.com.odnoklassniki.Odnoklassniki;
	import business.api.Wrapper;

	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class OKWrapper extends Wrapper {
		
		private var _activityID: int;
		
		public function OKWrapper($stage: Sprite, $flashVars: Object) {
			super($stage, $flashVars);
			
			Odnoklassniki.initialize($stage, $flashVars["secret"]);
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleCallback);
		}
		
		override public function init():void {
			_uid = _flashVars["logged_user_id"];
			
			_social = SOCIAL_OK;
			
			_url = "http://odnoklassniki.ru/games/"+_flashVars["app_name"];
			
			_opened_from = {};
			_opened_from.post_id = _flashVars["post_id"];
			_opened_from.user_id = _flashVars["referer"];
			_opened_from.full = true;
		}
		
		override public function getMe():void {
			var task: GetOkUsersTask = new GetOkUsersTask(GET_USERS, [uid], handleLoadUsers);
			task.run();
		}
		
		override public function getUsers($users: Array):void {
			var task: GetOkUsersTask = new GetOkUsersTask(GET_USERS, $users, handleLoadUsers);
			task.run();
		}
		
		override public function getFriends():void {
			var task: GetOkUsersTask = new GetOkUsersTask(GET_FRIENDS, null, handleLoadFriends);
			task.run();
		}
		
		override public function getAppFriends():void {
			var task: GetOkUsersTask = new GetOkUsersTask(GET_APP_FRIENDS, null, handleLoadAppFriends);
			task.run();
		}
		
		override public function wallPost($data: Object):void {
			Stream.publish($data.confirmation, $data.text, handleWallpost, null, $data.attachment, $data.action_links);
			_activityID = setInterval(handleWallpost, 5000, {});
		}
		
		override public function inviteFriend($text: String = null):void {
			Odnoklassniki.showInvite($text);
		}
		
		override public function showPayment($data: Object):void {
			Odnoklassniki.showPayment($data.name, $data.description, $data.code, $data.value, null, null, 'ok', 'true');
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
		
		private function handleWallpost($data : Object) : void {
			clearInterval(_activityID);
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, WALL_POST, true, false));
		}
		
		private function handleCallback(e : ApiCallbackEvent) : void {
		}
		
		override public function refresh($params: String):void {
			navigateToUrl(_url+$params, "_blank");
		}
	}
}
