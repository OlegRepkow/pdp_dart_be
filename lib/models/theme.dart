class Theme {
  final Map<String, dynamic> dark;
  final Map<String, dynamic> light;

  Theme({
    required this.dark,
    required this.light,
  });

  // Конструктор для створення з JSON
  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      dark: json['dark'] is Map<String, dynamic>
          ? json['dark'] as Map<String, dynamic>
          : Map<String, dynamic>.from(json['dark'] as Map),
      light: json['light'] is Map<String, dynamic>
          ? json['light'] as Map<String, dynamic>
          : Map<String, dynamic>.from(json['light'] as Map),
    );
  }

  // Метод для конвертації в JSON
  Map<String, dynamic> toJson() {
    return {
      'dark': dark,
      'light': light,
    };
  }
}
