import 'dart:async';
import 'dart:collection';

import 'models/task_model.dart';
import 'firebase/firebase_service.dart';

class TaskQueue {
  final FirebaseService _firebaseService;
  final Queue<Task> _queue = Queue<Task>();
  final StreamController<List<Task>> _queuedTasksController =
      StreamController<List<Task>>.broadcast();
  bool _isProcessing = false;
  Timer? _processingTimer;

  static const int _maxRetries = 3;
  static const int _processingDelay = 5;

  TaskQueue(this._firebaseService);

  Stream<List<Task>> get queuedTasks => _queuedTasksController.stream;

  void addTask(Task task) {
    _queue.add(task);
    _notifyQueueChanged();
    _startProcessing();
  }

  int get length => _queue.length;

  void _startProcessing() {
    if (!_isProcessing && _queue.isNotEmpty) {
      _isProcessing = true;
      _processNextTask();
    }
  }

  void _processNextTask() {
    if (_queue.isEmpty) {
      _isProcessing = false;
      return;
    }

    _processingTimer = Timer(Duration(seconds: _processingDelay), () async {
      final task = _queue.removeFirst();
      _notifyQueueChanged();

      try {
        final taskId = await _firebaseService.addTask(task);

        await _firebaseService.updateTaskStatus(taskId, TaskStatus.uploaded);
      } catch (e) {
        if (task.retryCount < _maxRetries) {
          final retryTask = task.copyWith(
            retryCount: task.retryCount + 1,
            status: TaskStatus.failed,
          );
          _queue.addFirst(retryTask);
          _notifyQueueChanged();
        } else {
          if (task.id != null) {
            await _firebaseService.updateTaskStatus(
              task.id!,
              TaskStatus.failed,
            );
          }
        }
      }

      _processNextTask();
    });
  }

  void _notifyQueueChanged() {
    _queuedTasksController.add(_queue.toList());
  }

  void dispose() {
    _processingTimer?.cancel();
    _queuedTasksController.close();
  }
}
