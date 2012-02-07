package business.tasks {
	import flash.utils.ByteArray;
	import business.utils.MultipartURLLoader;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import business.event.WrapperEvent;
	import business.api.VKWrapper;

	/**
	 * @author virich
	 */
	public class WallPostTask extends Task {
		
		private static var storage: Object = {};
		
		private var _external: Object;
		
		private var _server_url: String;
		
		private var _wall_id: String;
		private var _image : String;
		private var _message : String;
		private var _post_id : String;
		
		public function WallPostTask($external: Object, $data: Object) {
			_external = $external;
			_wall_id = $data.wall_id;
			_image = $data.image;
			_message = $data.message;
			_post_id = $data.post_id;
		}
		
		override public function run():void {
			getPhotoUploadServer();
		}
		
		private function getPhotoUploadServer() : void {
			var task: APITask = new APITask(VKWrapper.GET_PHOTO_UPLOAD_SERVER, {}, APITask.API, _external);
			task.addEventListener(WrapperEvent.DATA_RECIEVED, loadImage);
			task.run();
		}
		
		private function loadImage(e: WrapperEvent):void {
			_server_url = e.response.upload_url;
			sendPhoto(storage[_image]);
		}
		
		private function handleLoadImage(e: Event):void {
			storage[_image] = e.currentTarget.data;
			sendPhoto(storage[_image]);
		}

		private function sendPhoto($photo: ByteArray) : void {
			if ($photo) {
				var mpl: MultipartURLLoader = new MultipartURLLoader();
				mpl.addFile($photo, "image.png", "photo");
				mpl.addEventListener(Event.COMPLETE, sendPost);
				mpl.load(_server_url);
			} else {
				var loader: URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load(new URLRequest(_image));
				loader.addEventListener(Event.COMPLETE, handleLoadImage);
			}
		}

		private function sendPost(e : Event = null) : void {
			var response: Object = JSON.decode(e.target.loader.data);
			var server: String = response.server;
			var photo: String = response.photo;
			var hash: String = response.hash;
			var task: APITask = new APITask(VKWrapper.WALL_SAVE_POST, {"wall_id": _wall_id, "post_id": _post_id, "server": server, "photo": photo, "hash": hash, "message": _message}, APITask.API, _external);
			task.addEventListener(WrapperEvent.DATA_RECIEVED, handleSendPost);
			task.run();
		}

		private function handleSendPost(e : WrapperEvent) : void {
			var task: APITask = new APITask(VKWrapper.SAVE_WALL_POST, e.response.post_hash, APITask.CALL_METHOD, _external);
			task.addEventListener(WrapperEvent.DATA_RECIEVED, handleComplete);
			task.run();
		}

		private function handleComplete(e : WrapperEvent) : void {
			complete();
		}
	}
}
