class CVModel {
  String name;
  String email;
  int gender;
  String position;
  bool status;
  List<Role> role;
  List<Education> education;
  List<String> technicalSummaryList;
  List<String> skillList;
  List<Skills> skills;

  CVModel(
      {this.name,
      this.role,
      this.email,
      this.gender,
      this.position,
      this.status,
      this.technicalSummaryList,
      this.education,
        this.skillList,
        this.skills
      });
}

class Role {
  String roleNm;
  List<String> level;
  List<String> technicals;

  Role({this.roleNm, this.level, this.technicals});
}
class Education{
  String schoolNm;
  String majorMn;
  String classYear;
  Education({this.schoolNm , this.majorMn , this.classYear});
}
class Skills{
  String skillNm;
  String skillData;
  Skills({this.skillNm,this.skillData});
}




