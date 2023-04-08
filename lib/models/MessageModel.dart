class MessageModel {
  String? receiverId;
  String? senderId;
  String? messageType;
  String? message;
  String? sendTime;
  String? viewStatus;

  MessageModel(
      {this.receiverId,
        this.senderId,
        this.messageType,
        this.message,
        this.sendTime,
        this.viewStatus});

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    messageType = json['messageType'];
    message = json['message'];
    sendTime = json['sendTime'];
    viewStatus = json['view_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiverId'] = this.receiverId;
    data['senderId'] = this.senderId;
    data['messageType'] = this.messageType;
    data['message'] = this.message;
    data['sendTime'] = this.sendTime;
    data['view_status'] = this.viewStatus;
    return data;
  }
}