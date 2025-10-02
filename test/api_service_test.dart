import 'package:flutter_test/flutter_test.dart';
import 'package:get_calley/models/stats.dart';
import 'package:get_calley/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User.fromJson should parse correctly', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '9876543210',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '9876543210');
    });

    test('User.toJson should serialize correctly', () {
      final user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '9876543210',
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '9876543210');
    });
  });

  group('Stats Model Tests', () {
    test('Stats.fromJson should parse correctly', () {
      final json = {
        'totalCalls': 150,
        'pendingCalls': 25,
        'completedCalls': 100,
        'scheduledCalls': 25,
        'callsByDay': [
          {'day': 'Mon', 'calls': 20},
          {'day': 'Tue', 'calls': 35},
        ],
      };

      final stats = Stats.fromJson(json);

      expect(stats.totalCalls, 150);
      expect(stats.pendingCalls, 25);
      expect(stats.completedCalls, 100);
      expect(stats.scheduledCalls, 25);
      expect(stats.callsByDay.length, 2);
      expect(stats.callsByDay[0].day, 'Mon');
      expect(stats.callsByDay[0].calls, 20);
    });

    test('Stats handles missing data gracefully', () {
      final json = <String, dynamic>{};

      final stats = Stats.fromJson(json);

      expect(stats.totalCalls, 0);
      expect(stats.pendingCalls, 0);
      expect(stats.completedCalls, 0);
      expect(stats.scheduledCalls, 0);
      expect(stats.callsByDay, isEmpty);
    });
  });
}
