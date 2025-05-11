import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../widgets/task_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(TaskInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      state.user.email ?? 'Logged in',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final allTasks = [...state.tasks, ...state.queuedTasks];

            if (allTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No tasks yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/add'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add your first task'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                if (state.queuedTasks.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.amber.shade100,
                    child: Row(
                      children: [
                        const Icon(Icons.timelapse, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '${state.queuedTasks.length} task(s) in queue',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                // Task list
                Expanded(
                  child: ListView.builder(
                    itemCount: allTasks.length,
                    itemBuilder: (context, index) {
                      final task = allTasks[index];
                      return TaskTile(task: task);
                    },
                  ),
                ),
              ],
            );
          } else if (state is TaskFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(TaskInitialize());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No tasks available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
