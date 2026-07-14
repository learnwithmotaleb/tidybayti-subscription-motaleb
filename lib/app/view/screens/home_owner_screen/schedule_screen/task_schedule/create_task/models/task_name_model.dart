class TaskNameModel {
  int? statusCode;
  bool? success;
  String? message;
  List<TaskNameData>? data;

  TaskNameModel({this.statusCode, this.success, this.message, this.data});

  TaskNameModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskNameData>[];
      json['data'].forEach((v) {
        data!.add(new TaskNameData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskNameData {
  String? title;
  String? recurrence;
  String? rrule;

  TaskNameData({this.title, this.recurrence, this.rrule});

  TaskNameData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    recurrence = json['recurrence'];
    rrule = json['rrule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['recurrence'] = this.recurrence;
    data['rrule'] = this.rrule;
    return data;
  }
}
