class Stats {
  final int totalCalls;
  final int pendingCalls;
  final int completedCalls;
  final int scheduledCalls;
  final List<CallsByDay> callsByDay;

  Stats({
    required this.totalCalls,
    required this.pendingCalls,
    required this.completedCalls,
    required this.scheduledCalls,
    required this.callsByDay,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalCalls: json['totalCalls'] ?? 0,
      pendingCalls: json['pendingCalls'] ?? 0,
      completedCalls: json['completedCalls'] ?? 0,
      scheduledCalls: json['scheduledCalls'] ?? 0,
      callsByDay: (json['callsByDay'] as List<dynamic>?)
              ?.map((e) => CallsByDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCalls': totalCalls,
      'pendingCalls': pendingCalls,
      'completedCalls': completedCalls,
      'scheduledCalls': scheduledCalls,
      'callsByDay': callsByDay.map((e) => e.toJson()).toList(),
    };
  }
}

class CallsByDay {
  final String day;
  final int calls;

  CallsByDay({
    required this.day,
    required this.calls,
  });

  factory CallsByDay.fromJson(Map<String, dynamic> json) {
    return CallsByDay(
      day: json['day'] ?? '',
      calls: json['calls'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'calls': calls,
    };
  }
}
