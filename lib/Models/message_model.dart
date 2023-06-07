class Message{
  final String id;
  final String content;
  final DateTime dateTime;
  final String type;
  final bool seen;

  Message(this.id, this.content, this.dateTime, this.type, this.seen);
}