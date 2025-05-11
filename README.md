# ToDo Flutter App with Firebase

A simple ToDo app built with Flutter and Firebase. The app allows users to:

- Sign in using Firebase Auth (email/password).
- Add tasks that are stored in Firestore.
- Use a custom asynchronous queue to upload tasks after a 5 second delay with retry logic.
- View tasks in real-time.

## Features

- **User Authentication**: Firebase email/password authentication.
- **Task Management**:
  - Add, and view tasks.
  - Tasks are stored in Firestore under the user's UID.
  - Tasks have a status indicator (Queued vs. Uploaded).
- **Asynchronous Queue**: Custom-built queue to delay uploads to Firestore with retry logic.
- **Routing**: Uses `go_router` for navigation between login, dashboard, and task creation screens.
- **Clean Architecture**: The project follows a clean architecture with separate layers for:
  - `data/`: Firebase + queue logic.
  - `bloc/`: BLoC for managing app state (Authentication, Task).
  - `ui/`: Screens.
  - `models/`: Task model and other data models.

## Tech Stack

- **Flutter 3.x**
- **Firebase**:
  - Firebase Auth for user authentication.
  - Firestore for task management.
- **flutter_bloc**: For state management.
- **go_router**: For routing.
- **Firebase CLI**: For Firebase configuration.

## Folder Structure

lib/
 ├── bloc/
 │   ├── auth/
 │   │   ├── auth_bloc.dart
 │   │   ├── auth_event.dart
 │   │   ├── auth_state.dart
 │   ├── task/
 │   │   ├── task_bloc.dart
 │   │   ├── task_event.dart
 │   │   ├── task_state.dart
 ├── data/
 │   ├── firebase/
 │   │   ├── firebase_service.dart
 │   ├── models/
 │   │   ├── task_model.dart
 │   ├── task_queue.dart
 ├── ui/
 │   ├── screens/
 │   │   ├── login_screen.dart
 │   │   ├── dashboard_screen.dart
 │   │   ├── add_task_screen.dart
 │   ├── widgets/
 │   │   ├── task_tile.dart
 └── main.dart


 https://github.com/user-attachments/assets/c84a337a-1786-4c55-8588-462302654b1c
