import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(task.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getStatusIcon(task.status),
                  size: 16,
                  color: _getStatusColor(task.status),
                ),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(task.status),
                  style: TextStyle(
                    color: _getStatusColor(task.status),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(task.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            if (task.retryCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Retry count: ${task.retryCount}',
                  style: TextStyle(
                    color:
                        task.status == TaskStatus.failed
                            ? Colors.red
                            : Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.queued:
        return Icons.timelapse;
      case TaskStatus.uploaded:
        return Icons.check_circle;
      case TaskStatus.failed:
        return Icons.error;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.queued:
        return Colors.amber;
      case TaskStatus.uploaded:
        return Colors.green;
      case TaskStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.queued:
        return 'Queued';
      case TaskStatus.uploaded:
        return 'Uploaded';
      case TaskStatus.failed:
        return 'Failed';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy - h:mm a').format(date);
  }
}
