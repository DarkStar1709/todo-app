import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_task/ui/screens/add_task_screen.dart';
import 'package:todo_task/ui/screens/dashboard_screen.dart';
import 'package:todo_task/ui/screens/login_screen.dart';

class AppRouter {
  AppRouter();

  // Private navigators
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isLoggingIn = state.uri.toString() == '/login';

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on login page, redirect to dashboard
      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(path: '/add', builder: (context, state) => const AddTaskScreen()),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
