class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? githubUsername;
  final double? placementReadinessScore;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.githubUsername,
    this.placementReadinessScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'githubUsername': githubUsername,
      'placementReadinessScore': placementReadinessScore,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      githubUsername: map['githubUsername'],
      placementReadinessScore: map['placementReadinessScore']?.toDouble(),
    );
  }
}
