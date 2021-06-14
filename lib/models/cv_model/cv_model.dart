class CVModel {
  String name;
  String email;
  String gender;
  String position;
  bool status;
  Role role;
  List<Education> educationList;
  List<String> technicalSummaryList;
  List<Certificate> certificateList;
  List<Skill> skills;
  List<Professional> professionalList;
  List<HighLightProject> highLightProjectList;

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
      this.certificateList,
      this.highLightProjectList});
}

class Role {
  String roleNm;
  List<String> level;
  List<String> technicals;

  Role({this.roleNm, this.level, this.technicals});
}

class Education {
  String schoolNm;
  String majorNm;
  String classYear;

  Education({this.schoolNm, this.majorNm, this.classYear});
}

class Skill {
  String skillNm;
  String skillData;

  Skill({this.skillNm, this.skillData});
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

class HighLightProject {
  String projectNm;
  String projectDescriptionNm;
  String teamSize;
  String position;
  List<String> responsibility;
  List<String> technologies;

  HighLightProject(
      {this.projectDescriptionNm,
      this.teamSize,
      this.position,
      this.responsibility,
      this.technologies,
      this.projectNm});
}
