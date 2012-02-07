package business.event {
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;

	/**
	 * @author virich
	 */
	public class WrapperEvent extends Event {
		
		public static const INIT: String = "init_WrapperEvent";
		
		public static const SOCIAL_EVENT: String = "social_event_WrapperEvent";
		
		public static const DATA_RECIEVED: String = "data_recieved_WrapperEvent";
		public static const DATA_ERROR: String = "data_error_WrapperEvent";
		
		private var _method: String;
		public function get method():String {
			return _method;
		}
		
		private var _response: Object;
		public function get response():Object {
			return _response;
		}
		
		public function WrapperEvent($type: String, $method: String, $response: Object, $decode: Boolean = true) {
			_method = $method;
			_response = $decode && $response is String ? JSON.decode($response as String) : $response;
			super($type, true);
		}
		
		override public function clone():Event {
			return new WrapperEvent(type, method, response);
		}
	}
}
