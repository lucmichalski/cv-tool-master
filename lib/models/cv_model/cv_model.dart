class CVModel {
  String name;
  String email;
  int gender;
  String position;
  bool status;
  List<Role> role;
  Education education;
  List<String> technicalSummaryList;
  List<String> skillList;

  CVModel(
      {this.name,
      this.role,
      this.email,
      this.gender,
      this.position,
      this.status,
      this.technicalSummaryList,
      this.education,
        this.skillList
      });
}

class Role {
  String roleNm;
  List<String> level;
  List<String> technicals;

  Role({this.roleNm, this.level, this.technicals});
}
class Education{
  List<String> schools;
  List<String> majors;
  List<String> year;
  Education({this.schools , this.majors , this.year});
}




