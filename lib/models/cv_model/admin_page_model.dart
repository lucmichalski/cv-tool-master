// class TechnicalModel{
//   String role;
//   List<String> level;
//   List<String> technical;
//   TechnicalModel({this.role,this.level,this.technical});
// }

class MasterData {
  List<RoleData> roles;

  MasterData({this.roles});
}

class RoleData {
  String roleNm;
  List<LevelData> levelDataList;

  RoleData({this.roleNm, this.levelDataList});
}

class LevelData {
  String levelName;
  List<String> technicalDataList;

  LevelData({this.levelName, this.technicalDataList});
}
