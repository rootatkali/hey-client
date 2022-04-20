import 'package:hey/model/interest.dart';
import 'package:hey/model/school.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_view.g.dart';

@JsonSerializable()
class FriendView {
  String id;
  String username;
  String firstName;
  String lastName;
  String? status;
  bool initiated;
  String bio;
  School school;
  List<Interest> interests;
  String? hometown;
  double distance;
  int grade;
  String gender;
  double matchScore;

  FriendView(
      {required this.id,
      required this.username,
      required this.firstName,
      required this.lastName,
      this.status,
      required this.initiated,
      required this.bio,
      required this.school,
      required this.interests,
      this.hometown,
      required this.distance,
      required this.grade,
      required this.gender,
      required this.matchScore});

  factory FriendView.fromJson(Map<String, dynamic> json) =>
      _$FriendViewFromJson(json);

  Map<String, dynamic> toJson() => _$FriendViewToJson(this);

  String get name => '$firstName $lastName';

  @override
  String toString() {
    return 'FriendView{'
        'id: $id, '
        'username: $username, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'status: $status, '
        'initiated: $initiated, '
        'bio: $bio, '
        'school: $school, '
        'interests: $interests, '
        'hometown: $hometown, '
        'distance: $distance, '
        'grade: $grade, '
        'gender: $gender, '
        'matchScore: $matchScore'
        '}';
  }
}
