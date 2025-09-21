class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // Конструктор для створення з JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      createdAt: json['created_at'] is DateTime
          ? json['created_at'] as DateTime
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] is DateTime
          ? json['updated_at'] as DateTime
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  // Метод для конвертації в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Конструктор для створення нового todo
  factory Todo.create({
    required String title,
    String? description,
  }) {
    final now = DateTime.now();
    return Todo(
      id: '', // Буде встановлено при збереженні в БД
      title: title,
      description: description,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Метод для оновлення todo
  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
