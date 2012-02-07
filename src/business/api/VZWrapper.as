package business.api {
	import business.api.VKWrapper;

	import flash.display.Sprite;

	/**
	 * @author virich
	 */
	public class VZWrapper extends VKWrapper {
		
		public function VZWrapper($stage : Sprite, $flashVars : Object) {
			super($stage, $flashVars);
		}
		
		override public function init():void {
			_uid = _flashVars["viewer_id"];
			
			_social = SOCIAL_VZ;
			
//			_url = "http://vkontakte.ru/app"+_flashVars["api_id"];
			
			if (_flashVars["post_id"]) {
				_opened_from = {};
				_opened_from.post_id = _flashVars["post_id"];
				_opened_from.full = _flashVars["referrer"]!="wall_view_inline";
				_opened_from.user_id = _flashVars["poster_id"];
			}
		}
	}
}
