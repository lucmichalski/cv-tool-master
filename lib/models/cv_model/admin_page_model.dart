class MasterData {
  List<RoleData> roles;
  List<String> skills;
  List<String> technology;
  MasterData({this.roles,this.skills,this.technology});
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

