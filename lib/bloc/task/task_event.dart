import 'package:equatable/equatable.dart';

import '../../data/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitialize extends TaskEvent {}

class TaskAdd extends TaskEvent {
  final String title;
  final String description;

  TaskAdd({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;

  TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class QueuedTasksUpdated extends TaskEvent {
  final List<Task> queuedTasks;

  QueuedTasksUpdated(this.queuedTasks);

  @override
  List<Object?> get props => [queuedTasks];
}

class TaskError extends TaskEvent {
  final String message;

  TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
