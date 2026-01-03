class Theme {
  final String mode;
  final Map<String, dynamic> data;

  Theme({
    required this.mode,
    required this.data,
  });

  // Конструктор для створення з JSON
  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      mode: json['mode'] as String,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  // Метод для конвертації в JSON
  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'data': data,
    };
  }
}
