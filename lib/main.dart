import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/router/app_router.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/task/task_bloc.dart';
import 'data/firebase/firebase_service.dart';
import 'data/task_queue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseService firebaseService = FirebaseService();
  final TaskQueue taskQueue = TaskQueue(firebaseService);
  final AppRouter appRouter = AppRouter();

  runApp(
    MyApp(
      firebaseService: firebaseService,
      taskQueue: taskQueue,
      appRouter: appRouter,
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService;
  final TaskQueue taskQueue;
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.firebaseService,
    required this.taskQueue,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(firebaseService)),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(firebaseService, taskQueue),
        ),
      ],
      child: MaterialApp.router(
        title: 'ToDo Queue App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: appRouter.router,
      ),
    );
  }
}
