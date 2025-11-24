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

  // Dummy data for now - will be replaced with Firebase data
  factory UserProfile.dummy() {
    return UserProfile(
      name: 'Itumeleng Seema',
      email: 'Itumeleng@gmail.com',
      profileImageUrl: 'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
      bio: 'Gotta catch \'em all!',
      joinedDate: DateTime(2024, 1, 15),
    );
  }
}
