class UserModel {
  String uid;
  String employeeName;
  String email;
  String employeeId;
  String phoneNumber;
  String? profilePicture;
  String? reason;
  String? siteId;
  String? state;
  String? taskId;
  String? aadhaarNumber;
  String? allocatedDate;
  String? availability;

  UserModel({
    required this.uid,
    required this.employeeName,
    required this.email,
    required this.employeeId,
    required this.phoneNumber,
    this.profilePicture,
    this.reason,
    this.siteId,
    this.state,
    this.taskId,
    this.aadhaarNumber,
    this.allocatedDate,
    this.availability,
  });


  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      employeeName: json['Employee Name'] ?? '',
      email: json['Email'] ?? '',
      employeeId: json['Employee ID'] ?? '',
      phoneNumber: json['Phone Number'] ?? '',
      profilePicture: json['Profile Picture'],
      reason: json['Reason'],
      siteId: json['Site Id'],
      state: json['state'],
      taskId: json['taskId'],
      aadhaarNumber: json['Aadhaar Number'],
      allocatedDate: json['Allocated Date'],
      availability: json['Availability'], // Available or Unavailable
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'Employee Name': employeeName,
      'Email': email,
      'Employee ID': employeeId,
      'Phone Number': phoneNumber,
      'Profile Picture': profilePicture,
      'Reason': reason,
      'Site Id': siteId,
      'state': state,
      'taskId': taskId,
      'Aadhaar Number': aadhaarNumber,
      'Allocated Date': allocatedDate,
      'Availability': availability,
    };
  }
}
