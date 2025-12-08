class Pokemon {
  final String name;
  final String url;
  final String? imageUrl;

  Pokemon({required this.name, required this.url, this.imageUrl});

  String get id => url.split('/').where((e) => e.isNotEmpty).last;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
