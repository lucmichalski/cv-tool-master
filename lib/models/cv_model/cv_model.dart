class CVModel {
  String name;
  String email;
  int gender;
  String position;
  bool status;
  List<Role> role;
  List<Education> educationList;
  List<String> technicalSummaryList;
  List<Certificate> certificateList;
  List<Skills> skills;
  List<Professional> professionalList;

  CVModel(
      {this.name,
      this.role,
      this.email,
      this.gender,
      this.position,
      this.status,
      this.technicalSummaryList,
      this.educationList,
      this.skills,
      this.professionalList,
      this.certificateList});
}

class Role {
  String roleNm;
  List<String> level;
  List<String> technicals;

  Role({this.roleNm, this.level, this.technicals});
}

class Education {
  String schoolNm;
  String majorMn;
  String classYear;

  Education({this.schoolNm, this.majorMn, this.classYear});
}

class Skills {
  String skillNm;
  String skillData;

  Skills({this.skillNm, this.skillData});
}

class Certificate {
  String certificateNm;
  String certificateYear;

  Certificate({this.certificateNm, this.certificateYear});
}

class Professional {
  String companyNm;
  String locationNm;
  String startDate;
  String endDate;
  String roleNm;
  List<String> responsibilities;

  Professional(
      {this.companyNm,
      this.locationNm,
      this.startDate,
      this.endDate,
      this.roleNm,
      this.responsibilities});
}
