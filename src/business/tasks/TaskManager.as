package business.tasks {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class TaskManager extends EventDispatcher {
		
		private var _tasks: Vector.<Task>;
		
		private var _currentTasks: Array = [];
		public function get processing():Boolean {
			return Boolean(_currentTasks.length>0);
		}
		
		private static var _instances : Vector.<TaskManager>;
		private static var _allowInstantiation : Boolean = false;
		public static function get thread():int {
			return _instances.length;
		}
		
		private static var _paused: Boolean;
		public static function set paused($paused: Boolean):void {
			_paused = $paused;
			if (!_paused) {
				for (var i : int = 0; i < _instances.length; i++) {
					_instances[i].continueTask();
				}
			}
		}
		
		private var _nextWhilePaused: Boolean;

		public function TaskManager() {
			if (!_allowInstantiation) {
				throw new Error("Can't instantiate TaskManager class using new TaskManager(). Try TaskManager.getInstance().");
			}

			_tasks = new Vector.<Task>();
		}
		
		public static function getInstance($thread: int = 0):TaskManager {
			if (!_instances) {
				_instances = new Vector.<TaskManager>();
			}
			if (_instances.length<=$thread) {
				_allowInstantiation = true;
				_instances.push(new TaskManager());
				_allowInstantiation = false;
			}
			return $thread!=0 ? _instances[$thread] : _instances[thread-1];
		}
		
		public function addTask($task: Task):void {
			_tasks.push($task);
			
			run();
		}
		
		public function run():void {
			if (processing) {
				return;
			}
			next();
		}
		
		public function addCurrentTask($task: Task):void {
			if ($task) {
				_currentTasks.push($task);
				$task.addEventListener(Task.TASK_COMPLETE, handleNext);
				$task.run();
			}
		}

		private function handleNext(e : Event) : void {
			if (e) {
				var task: Task = e.currentTarget as Task;
				for (var i : int = 0; i < _currentTasks.length; i++) {
					if (_currentTasks[i] == task) {
						task.removeEventListener(Task.TASK_COMPLETE, handleNext);
						_currentTasks.splice(i,1);
						break;
					}
				}
			}
			if (!processing) {
				next();
			}
		}
		
		public function continueTask():void {
			if (_nextWhilePaused) {
				_nextWhilePaused = false;
				next();
			}
		}
		
		private function next():void {
			if (_paused) {
				_nextWhilePaused = true;
				return;
			}
			var task: Task = _tasks.length>0 ? _tasks.shift() : null;
			addCurrentTask(task);
			
			if (!processing) {
				dispatchEvent(new Event(Task.TASK_COMPLETE));
			}
		}
		
		public function clear():void {
			_tasks = new Vector.<Task>();
		}
	}
}
