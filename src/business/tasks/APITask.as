package business.tasks {
	import vk.APIConnection;
	import business.event.WrapperEvent;

	/**
	 * @author virich
	 */
	public class APITask extends Task {
		
		public static const API: String = "api";
		public static const CALL_METHOD: String = "callMethod";
		
		protected var _method: String;
		protected var _params: Object;
		protected var _type : String;
		protected var _external: Object;
		protected var _callback: Function;
		
		public function APITask($method: String, $params: Object, $type: String, $external: Object, $callback: Function = null) {
			_method = $method;
			_params = $params;
			_type = $type;
			_external = $external;
			_callback = $callback;
		}
		
		override public function run():void {
			if (_external is APIConnection && _type==CALL_METHOD) {
				return;
			}
			_external[_type](_method, _params, handleComplete, handleError);
		}

		private function handleComplete(data: Object) : void {
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_RECIEVED, _method, data));
			complete();
			
			if (_callback!=null) {
				_callback(data);
			}
		}
		
		private function handleError(data: Object) : void {
			dispatchEvent(new WrapperEvent(WrapperEvent.DATA_ERROR, _method, data.error_msg, false));
			complete();
		}
	}
}
