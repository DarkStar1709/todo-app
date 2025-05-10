import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/firebase/firebase_service.dart';
import '../../data/task_queue.dart';
import '../../data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseService _firebaseService;
  final TaskQueue _taskQueue;

  StreamSubscription? _tasksSubscription;
  StreamSubscription? _queuedTasksSubscription;

  TaskBloc(this._firebaseService, this._taskQueue) : super(TaskInitial()) {
    on<TaskInitialize>((event, emit) {
      emit(TaskLoading());

      _tasksSubscription?.cancel();
      _tasksSubscription = _firebaseService.tasksStream().listen(
        (tasks) {
          add(TasksUpdated(tasks));
        },
        onError: (error) {
          add(TaskError(error.toString()));
        },
      );

      _queuedTasksSubscription?.cancel();
      _queuedTasksSubscription = _taskQueue.queuedTasks.listen((queuedTasks) {
        add(QueuedTasksUpdated(queuedTasks));
      });
    });

    on<TaskAdd>((event, emit) {
      try {
        final task = Task(title: event.title, description: event.description);

        _taskQueue.addTask(task);
      } catch (e) {
        emit(TaskError('Failed to add task: ${e.toString()}') as TaskState);
      }
    });

    on<TasksUpdated>((event, emit) {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(
          TaskLoaded(tasks: event.tasks, queuedTasks: currentState.queuedTasks),
        );
      } else {
        emit(TaskLoaded(tasks: event.tasks, queuedTasks: const []));
      }
    });

    on<QueuedTasksUpdated>((event, emit) {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(
          TaskLoaded(tasks: currentState.tasks, queuedTasks: event.queuedTasks),
        );
      } else {
        emit(TaskLoaded(tasks: const [], queuedTasks: event.queuedTasks));
      }
    });

    on<TaskError>((event, emit) {
      emit(TaskFailure(event.message));
    });
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    _queuedTasksSubscription?.cancel();
    return super.close();
  }
}
