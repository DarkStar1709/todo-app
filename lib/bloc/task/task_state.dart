import 'package:equatable/equatable.dart';

import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> queuedTasks;

  TaskLoaded({required this.tasks, required this.queuedTasks});

  @override
  List<Object?> get props => [tasks, queuedTasks];
}

class TaskFailure extends TaskState {
  final String message;

  TaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}
