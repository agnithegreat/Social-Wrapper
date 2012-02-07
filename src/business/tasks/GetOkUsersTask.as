package business.tasks {
	import api.com.odnoklassniki.sdk.users.Users;
	import business.api.Wrapper;
	import api.com.odnoklassniki.sdk.friends.Friends;

	/**
	 * @author virich
	 */
	public class GetOkUsersTask extends Task {
		
		private var _type: String;
		private var _users: Array;
		private var _callback: Function;
		
		public function GetOkUsersTask($type: String, $users: Array, $callback: Function) {
			_type = $type;
			_users = $users;
			_callback = $callback;
		}
		
		override public function run():void {
			switch (_type) {
				case Wrapper.GET_USERS:
					getProfiles(_users);
					break;
				case Wrapper.GET_FRIENDS:
					Friends.get(getProfiles, null);
					break;
				case Wrapper.GET_APP_FRIENDS:
					Friends.getAppUsers(getProfiles);
					break;
			}
		}

		private function getProfiles($data : Object) : void {
			var users : Array = $data as Array ? $data as Array : ($data.uids ? $data.uids : []);
			if (users.length>0) {
				Users.getInfo(users, ["uid","first_name","last_name","pic_1","gender"], handleComplete);
			} else {
				handleComplete(null);
			}
		}

		private function handleComplete($data : Object) : void {
			complete();
			_callback($data);
		}
	}
}
