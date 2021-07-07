class CVModel {
  String id;
  String name;
  String email;
  String gender;
  String position;
  bool status;
  List<Role> role;
  List<String> technicalSummaryList;
  List<EducationList> educationList;
  List<CertificateList> certificateList;
  List<Skills> skills;
  List<ProfessionalList> professionalList;
  List<HighLightProjectList> highLightProjectList;
  List<Languages> languages;
  String createdDate;
  String strCreatedDate;

  CVModel(
      {this.id,
      this.name,
      this.email,
      this.gender,
      this.position,
      this.status,
      this.role,
      this.technicalSummaryList,
      this.educationList,
      this.certificateList,
      this.skills,
      this.professionalList,
      this.highLightProjectList,
      this.languages,
      this.createdDate,
      this.strCreatedDate
      });

  CVModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String;
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    position = json['position'];
    status = json['status'];
    if (json['role'] != null) {
      role =  [];
      json['role'].forEach((v) {
        role.add(new Role.fromJson(v));
      });
    }
    createdDate = json['createdDate'];
    strCreatedDate = json['strCreatedDate'];
    technicalSummaryList = json['technicalSummaryList'].cast<String>();
    if (json['educationList'] != null) {
      educationList =  [];
      json['educationList'].forEach((v) {
        educationList.add(new EducationList.fromJson(v));
      });
    }
    if (json['certificateList'] != null) {
      certificateList = [];
      json['certificateList'].forEach((v) {
        certificateList.add(new CertificateList.fromJson(v));
      });
    }
    if (json['skills'] != null) {
      skills =  [];
      json['skills'].forEach((v) {
        skills.add(new Skills.fromJson(v));
      });
    }
    if (json['professionalList'] != null) {
      professionalList = [];
      json['professionalList'].forEach((v) {
        professionalList.add(new ProfessionalList.fromJson(v));
      });
    }
    if (json['highLightProjectList'] != null) {
      highLightProjectList =[];
      json['highLightProjectList'].forEach((v) {
        highLightProjectList.add(new HighLightProjectList.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        languages.add(new Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['position'] = this.position;
    data['status'] = this.status;
    if (this.role != null) {
      data['role'] = this.role.map((v) => v.toJson()).toList();
    }
    data['technicalSummaryList'] = this.technicalSummaryList;
    if (this.educationList != null) {
      data['educationList'] =
          this.educationList.map((v) => v.toJson()).toList();
    }
    if (this.certificateList != null) {
      data['certificateList'] =
          this.certificateList.map((v) => v.toJson()).toList();
    }
    if (this.skills != null) {
      data['skills'] = this.skills.map((v) => v.toJson()).toList();
    }
    if (this.professionalList != null) {
      data['professionalList'] =
          this.professionalList.map((v) => v.toJson()).toList();
    }
    if (this.highLightProjectList != null) {
      data['highLightProjectList'] =
          this.highLightProjectList.map((v) => v.toJson()).toList();
    }
    if (this.languages != null) {
      data['languages'] = this.languages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Role {
  String roleNm;
  List<String> level;
  List<String> technicals;

  Role({this.roleNm, this.level, this.technicals});

  Role.fromJson(Map<String, dynamic> json) {
    roleNm = json['roleNm'];
    level = json['level'].cast<String>();
    technicals = json['technicals'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleNm'] = this.roleNm;
    data['level'] = this.level;
    data['technicals'] = this.technicals;
    return data;
  }
}

class EducationList {
  String schoolNm;
  String majorNm;
  String classYear;

  EducationList({this.schoolNm, this.majorNm, this.classYear});

  EducationList.fromJson(Map<String, dynamic> json) {
    schoolNm = json['schoolNm'];
    majorNm = json['majorNm'];
    classYear = json['classYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolNm'] = this.schoolNm;
    data['majorNm'] = this.majorNm;
    data['classYear'] = this.classYear;
    return data;
  }
}

class CertificateList {
  String certificateNm;
  String certificateYear;

  CertificateList({this.certificateNm, this.certificateYear});

  CertificateList.fromJson(Map<String, dynamic> json) {
    certificateNm = json['certificateNm'];
    certificateYear = json['certificateYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certificateNm'] = this.certificateNm;
    data['certificateYear'] = this.certificateYear;
    return data;
  }
}

class Skills {
  String skillNm;
  String skillData;
  bool isSelected;

  Skills({this.skillNm, this.skillData, this.isSelected});

  Skills.fromJson(Map<String, dynamic> json) {
    skillNm = json['skillNm'];
    skillData = json['skillData'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skillNm'] = this.skillNm;
    data['skillData'] = this.skillData;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class ProfessionalList {
  String companyNm;
  String locationNm;
  String startDate;
  String endDate;
  String roleNm;
  List<String> responsibilities;

  ProfessionalList(
      {this.companyNm,
        this.locationNm,
        this.startDate,
        this.endDate,
        this.roleNm,
        this.responsibilities});

  ProfessionalList.fromJson(Map<String, dynamic> json) {
    companyNm = json['companyNm'];
    locationNm = json['locationNm'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    roleNm = json['roleNm'];
    responsibilities = json['responsibilities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyNm'] = this.companyNm;
    data['locationNm'] = this.locationNm;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['roleNm'] = this.roleNm;
    data['responsibilities'] = this.responsibilities;
    return data;
  }
}

class HighLightProjectList {
  String projectNm;
  String projectDescription;
  String teamSize;
  String position;
  List<String> responsibility;
  List<String> technologies;
  String communicationused;
  String uiuxdesign;
  String documentcontrol;
  String projectmanagementtool;
  bool isExpand = false;

  HighLightProjectList(
      {this.projectNm,
        this.projectDescription,
        this.teamSize,
        this.position,
        this.responsibility,
        this.technologies,
        this.communicationused,
        this.uiuxdesign,
        this.documentcontrol,
        this.projectmanagementtool,
        this.isExpand = false});

  HighLightProjectList.fromJson(Map<String, dynamic> json) {
    projectNm = json['projectNm'];
    projectDescription = json['projectDescription'];
    teamSize = json['teamSize'];
    position = json['position'];
    responsibility = json['responsibility'].cast<String>();
    technologies = json['technologies'].cast<String>();
    communicationused = json['communicationused'];
    uiuxdesign = json['uiuxdesign'];
    documentcontrol = json['documentcontrol'];
    projectmanagementtool = json['projectmanagementtool'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectNm'] = this.projectNm;
    data['projectDescription'] = this.projectDescription;
    data['teamSize'] = this.teamSize;
    data['position'] = this.position;
    data['responsibility'] = this.responsibility;
    data['technologies'] = this.technologies;
    data['communicationused'] = this.communicationused;
    data['uiuxdesign'] = this.uiuxdesign;
    data['documentcontrol'] = this.documentcontrol;
    data['projectmanagementtool'] = this.projectmanagementtool;
    return data;
  }
}

class Languages {
  String languageNm;
  String level;
  int positionLanguage;
  int positionLevel;

  Languages(
      {this.languageNm, this.level, this.positionLanguage, this.positionLevel});

  Languages.fromJson(Map<String, dynamic> json) {
    languageNm = json['languageNm'];
    level = json['level'];
    positionLanguage = json['positionLanguage'];
    positionLevel = json['positionLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['languageNm'] = this.languageNm;
    data['level'] = this.level;
    data['positionLanguage'] = this.positionLanguage;
    data['positionLevel'] = this.positionLevel;
    return data;
  }
}