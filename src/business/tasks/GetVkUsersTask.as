package business.tasks {
	import business.api.VKWrapper;
	import business.event.WrapperEvent;

	/**
	 * @author virich
	 */
	public class GetVkUsersTask extends Task {
		
		private var _external : Object;
		private var _users : Array;
		private var _method: String;
		private var _callback: Function;
		
		public function GetVkUsersTask($external : Object, $users : Array, $method: String, $callback: Function) {
			_external = $external;
			_users = $users;
			_method = $method;
			_callback = $callback;
		}
		
		override public function run():void {
			getUsers();
		}
		
		private function getUsers():void {
			var task: APITask = new APITask(_method, _users ? {uids: _users.join(",")} : {}, APITask.API, _external, getProfiles);
			task.run();
		}

		private function getProfiles($data : Object) : void {
			var users: Array = $data as Array ? $data as Array : [];
			if (users.length>0) {
				var task : APITask = new APITask(VKWrapper.GET_PROFILES, {uids: users.join(","), fields: "photo"}, APITask.API, _external);
				task.addEventListener(WrapperEvent.DATA_RECIEVED, handleComplete);
				task.run();
			} else {
				handleComplete(null);
			}
		}

		private function handleComplete(e : WrapperEvent) : void {
			complete();
			_callback(e ? e.response : {});
		}
	}
}
