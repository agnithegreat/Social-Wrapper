package business.api {
	import flash.events.Event;
	import business.event.WrapperEvent;
	import mailru.MailruCall;
	import business.api.Wrapper;

	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class MMWrapper extends Wrapper {
		
		public function MMWrapper($stage: Sprite, $flashVars: Object) {
			super($stage, $flashVars);
			
			MailruCall.addEventListener(Event.COMPLETE, mailruReadyHandler);
			MailruCall.init('flash-app', $flashVars["secret"]);
		}
		
		override public function init():void {
			_uid = _flashVars["vid"];
			
			_social = SOCIAL_MM;
			
			_url = "http://my.mail.ru/apps/"+_flashVars["app_id"];
		}
		
		private function mailruReadyHandler(e: Event) : void {
			MailruCall.removeEventListener(Event.COMPLETE, mailruReadyHandler);
		}
		
		override public function getMe():void {
			MailruCall.exec("mailru.common.users.getInfo", handleLoadUsers, [uid]);
		}
		
		override public function getUsers($users: Array):void {
			MailruCall.exec("mailru.common.users.getInfo", handleLoadUsers, $users);
		}
		
		override public function getFriends():void {
			MailruCall.exec("mailru.common.friends.getExtended", handleLoadFriends);
		}
		
		override public function getAppFriends():void {
			MailruCall.exec("mailru.common.friends.getAppUsers", handleLoadAppFriends, 1);
		}
		
		override public function wallPost($data: Object):void {
			if ($data.uid) {
				MailruCall.exec("mailru.common.guestbook.post", null, $data);
			} else {
				MailruCall.exec("mailru.common.stream.post", null, $data);
			}
		}
		
		override public function inviteFriend($text: String = null):void {
			MailruCall.exec("mailru.app.friends.invite");
		}
		
		override public function showPayment($data: Object):void {
			MailruCall.exec("mailru.app.payments.showDialog", handlePayment, $data);
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
		
		private function handlePayment($data: Object):void {
			dispatchEvent(new WrapperEvent(WrapperEvent.SOCIAL_EVENT, BALANCE_CHANGED, null, false));
		}
	}
}
