enum TaskStatus { queued, uploaded, failed }

class Task {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final TaskStatus status;
  final int retryCount;

  Task({
    this.id,
    required this.title,
    required this.description,
    DateTime? createdAt,
    this.status = TaskStatus.queued,
    this.retryCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    TaskStatus? status,
    int? retryCount,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'retryCount': retryCount,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TaskStatus.queued,
      ),
      retryCount: json['retryCount'] ?? 0,
    );
  }

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt:
          data['createdAt'] != null
              ? DateTime.parse(data['createdAt'])
              : DateTime.now(),
      status:
          data['status'] != null
              ? TaskStatus.values.firstWhere(
                (e) => e.toString().split('.').last == data['status'],
                orElse: () => TaskStatus.uploaded,
              )
              : TaskStatus.uploaded,
      retryCount: data['retryCount'] ?? 0,
    );
  }
}
