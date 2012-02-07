package business.api {
	import flash.external.ExternalInterface;
	import api.com.adobe.json.JSON;
	import business.event.WrapperEvent;
	import business.api.Wrapper;

	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class FBWrapper extends Wrapper {
		
		public function FBWrapper($stage: Sprite, $flashVars: Object) {
			super($stage, $flashVars);
		}
		
		override public function init():void {
			_uid = _flashVars["uid"];
			
			_social = SOCIAL_FB;
			
			_url = _flashVars["url"];
			
			ExternalInterface.addCallback("updateStats", updateStats);
		}
		
		override public function getMe():void {
			var data: Object = JSON.decode(_flashVars["user"]);
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_USERS, parseUser(data)));
		}
		
		override public function getUsers($users: Array):void {
//			var data: Object = JSON.decode(_flashVars["user"]);
//			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_USERS, parseUser(data)));
		}
		
		override public function getFriends():void {
			var data: Object = JSON.decode(_flashVars["friend_list"]);
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_FRIENDS, parseUsers(data)));
		}
		
		override public function getAppFriends():void {
			var data: Object = JSON.decode(_flashVars["friend_list"]);
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, GET_APP_FRIENDS, parseUsers(data)));
		}
		
		override public function wallPost($data: Object):void {
			ExternalInterface.call("as.postToTheWall", $data.wall_id, $data.name, $data.picture, $data.caption, $data.description, $data.link);
		}
		
		override public function inviteFriend($text: String = null):void {
			ExternalInterface.call("as.inviteFriends");
		}
		
		override public function showPayment($data: Object):void {
			ExternalInterface.call("fb_credits.placeOrder", $data.code, $data.name, $data.description, $data.image);
		}
		
		private function updateStats():void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, BALANCE_CHANGED, null, false));
		}
	}
}
