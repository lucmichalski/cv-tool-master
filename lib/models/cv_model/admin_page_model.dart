class MasterData {
  String id;
  List<String> technicalUsed;
  List<String> skills;
  List<Summary> summary;
  List<CompanyMaster> companyMaster;
  List<ProjectMaster> projectMaster;

  MasterData(
      {this.id,
        this.technicalUsed,
        this.skills,
        this.summary,
        this.companyMaster,
        this.projectMaster});

  MasterData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String;
    technicalUsed = json['technical_used'].cast<String>();
    skills = json['skills'].cast<String>();
    if (json['summary'] != null) {
      summary = new List<Summary>();
      json['summary'].forEach((v) {
        summary.add(new Summary.fromJson(v));
      });
    }
    if (json['companyresponsibilities'] != null) {
      companyMaster = new List<CompanyMaster>();
      json['companyresponsibilities'].forEach((v) {
        companyMaster.add(new CompanyMaster.fromJson(v));
      });
    }
    if (json['projectresponsibilities'] != null) {
      projectMaster = new List<ProjectMaster>();
      json['projectresponsibilities'].forEach((v) {
        projectMaster.add(new ProjectMaster.fromJson(v));
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
    if (this.companyMaster != null) {
      data['companyresponsibilities'] =
          this.companyMaster.map((v) => v.toJson()).toList();
    }
    if (this.projectMaster != null) {
      data['projectresponsibilities'] =
          this.projectMaster.map((v) => v.toJson()).toList();
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
      levels = new List<Levels>();
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
      technicals = new List<Technicals>();
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

class CompanyMaster {
  String role;
  List<String> responsibilities;

  CompanyMaster({this.role, this.responsibilities});

  CompanyMaster.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    responsibilities = json['responsibilities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['responsibilities'] = this.responsibilities;
    return data;
  }
}
class ProjectMaster {
  String role;
  List<String> responsibilities;

  ProjectMaster({this.role, this.responsibilities});

  ProjectMaster.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    responsibilities = json['responsibilities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['responsibilities'] = this.responsibilities;
    return data;
  }
}