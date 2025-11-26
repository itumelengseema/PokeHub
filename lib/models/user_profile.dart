class UserProfile {
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final DateTime joinedDate;

  UserProfile({
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    required this.joinedDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'Pokémon Trainer',
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'] as String)
          : DateTime.now(),
    );
  }
}
