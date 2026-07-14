class TaskNameRoomModel {
  int? statusCode;
  bool? success;
  String? message;
  Map<String, List<TaskNameRoomModelData>>? data;

  TaskNameRoomModel({this.statusCode, this.success, this.message, this.data});

  TaskNameRoomModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = {};
      (json['data'] as Map).forEach((roomName, taskList) {
        data![roomName] = (taskList as List)
            .map((v) => TaskNameRoomModelData.fromJson(v))
            .toList();
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['statusCode'] = statusCode;
    result['success'] = success;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((roomName, taskList) {
        return MapEntry(
          roomName,
          taskList.map((v) => v.toJson()).toList(),
        );
      });
    }
    return result;
  }
}

class TaskNameRoomModelData {
  String? title;
  String? recurrence;

  TaskNameRoomModelData({this.title, this.recurrence});

  TaskNameRoomModelData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    recurrence = json['recurrence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['recurrence'] = recurrence;
    return data;
  }
}
