import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graduation2/Features/authentication/presentation/pages/login_page.dart';
import 'package:graduation2/Features/authentication/presentation/pages/signup_page.dart';
import 'package:graduation2/Features/bottombar/bottom_bar.dart';
import 'package:graduation2/Features/course_info/presentation/pages/course_details_page.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/Features/teacher/presentation/widgets/teacher_details.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String teacherDetails = '/details';
  static const String courseDetails = '/course-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      case '/':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: const RouteSettings(name: login),
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
          settings: const RouteSettings(name: signup),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const Bottombar(),
          settings: const RouteSettings(name: home),
        );
      case courseDetails:
        final args = settings.arguments;
        if (args is! int) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Invalid course id'))),
          );
        }
        return MaterialPageRoute(
          builder: (_) => CourseDetailsPage(courseId: args),
          settings: const RouteSettings(name: courseDetails),
        );
      case teacherDetails:
        final args = settings.arguments;

        if (args is! Map) {
          return _invalidRoute(
            'Invalid instructor data',
            routeName: teacherDetails,
          );
        }

        final teacher = args['teacher'];
        final image = args['image'];

        if (teacher is! TeacherModel || image is! Uint8List) {
          return _invalidRoute(
            'Invalid instructor data',
            routeName: teacherDetails,
          );
        }

        return MaterialPageRoute(
          builder: (_) => TeacherDetails(
            teacherModel: teacher,
            img: image,
          ),
          settings: const RouteSettings(name: teacherDetails),
        );
      default:
        return _invalidRoute('Route not found');

    }
  }

  static MaterialPageRoute<dynamic> _invalidRoute(
    String message, {
    String? routeName,
  }) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      settings: RouteSettings(name: routeName),
    );
  }
}
