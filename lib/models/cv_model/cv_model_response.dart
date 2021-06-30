import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

class ListCVResponse {
  int total;
  int page;
  int pageSize;
  int totalPages;
  int totalDraft;
  int totalCompleted;
  List<CVModel> items;

  ListCVResponse({this.total, this.page, this.pageSize, this.totalPages, this.items,this.totalDraft,this.totalCompleted});

  ListCVResponse.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    totalDraft = json['total_draft'];
    totalCompleted = json['total_completed'];
    pageSize = json['pageSize'];
    totalPages = json['total_pages'];
    if (json['items'] != null) {
      items =  [];
      json['items'].forEach((v) {
        items.add(new CVModel.fromJson(v));
      });
    }
  }
}
class DataPosition {
  String position;
  int total;


  DataPosition({this.position, this.total});

  DataPosition.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['total'] = this.total;
    return data;
  }
}