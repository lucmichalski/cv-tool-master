class MasterData {
  String id;
  List<String> technicalUsed;
  List<String> skills;
  List<Summary> summary;

  MasterData({this.id, this.technicalUsed, this.skills, this.summary});

  MasterData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String;
    technicalUsed = json['technical_used'].cast<String>();
    skills = json['skills'].cast<String>();
    if (json['summary'] != null) {
      summary = [];
      json['summary'].forEach((v) {
        summary.add(new Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['technical_used'] = this.technicalUsed;
    data['skills'] = this.skills;
    if (this.summary != null) {
      data['summary'] = this.summary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String role;
  List<Levels> levels;

  Summary({this.role, this.levels});

  Summary.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    if (json['levels'] != null) {
      levels = [];
      json['levels'].forEach((v) {
        levels.add(new Levels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    if (this.levels != null) {
      data['levels'] = this.levels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Levels {
  String levelName;
  List<Technicals> technicals;

  Levels({this.levelName, this.technicals});

  Levels.fromJson(Map<String, dynamic> json) {
    levelName = json['level_name'];
    if (json['technicals'] != null) {
      technicals = [];
      json['technicals'].forEach((v) {
        technicals.add(new Technicals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_name'] = this.levelName;
    if (this.technicals != null) {
      data['technicals'] = this.technicals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Technicals {
  String technicalName;
  List<String> summaryList;

  Technicals({this.technicalName, this.summaryList});

  Technicals.fromJson(Map<String, dynamic> json) {
    technicalName = json['technical_name'];
    summaryList = json['summary_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['technical_name'] = this.technicalName;
    data['summary_list'] = this.summaryList;
    return data;
  }
}
