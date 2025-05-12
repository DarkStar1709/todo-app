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

  ## 🧩 Task Queueing Logic

The `TaskQueue` class manages a **delayed, retryable task queue** for uploading tasks to Firebase.  
This is useful when you want to handle intermittent network conditions or ensure tasks are uploaded in sequence.

### 🔄 How It Works

#### ✅ Task Addition
- When a task is added using `addTask(Task task)`, it is appended to an internal `Queue<Task>`.
- The queue broadcasts its updated state through a stream (`queuedTasks`) for UI or logs.

#### ▶️ Automatic Processing
- If the queue isn't already processing, the `_startProcessing()` method kicks off the first upload.
- A new task is processed **every 5 seconds** (`_processingDelay`), one at a time.

#### 🚀 Task Execution
- The task at the front of the queue is dequeued and sent to Firebase via `addTask`.
- If the upload succeeds, its status is updated to `uploaded`.

#### 🔁 Retry Mechanism
- If the upload fails, the task’s `retryCount` is checked:
  - If below the retry limit (`_maxRetries = 3`), the task is re-queued at the front with `status: failed` and `retryCount` incremented.
  - Otherwise, it's marked as permanently `failed` using the task’s `id`.

#### 🔔 Real-Time Updates
- All queue changes are pushed to subscribers using `_queuedTasksController.stream`, enabling real-time UI updates.

#### 🧹 Cleanup
- Use `dispose()` to cancel the timer and close the stream when the queue is no longer needed.


## Folder Structure
```
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
```


 https://github.com/user-attachments/assets/c84a337a-1786-4c55-8588-462302654b1c
