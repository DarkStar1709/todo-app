import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Authentication methods
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore methods
  CollectionReference get _tasksCollection =>
      _firestore.collection('users/${currentUser?.uid}/tasks');

  Future<String> addTask(Task task) async {
    if (currentUser == null) {
      throw AuthException('User not authenticated');
    }

    try {
      final docRef = await _tasksCollection.add({
        'title': task.title,
        'description': task.description,
        'createdAt': task.createdAt.toIso8601String(),
        'status': task.status.toString().split('.').last,
        'retryCount': task.retryCount,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<void> updateTaskStatus(
    String taskId,
    TaskStatus status, {
    int? retryCount,
  }) async {
    if (currentUser == null) {
      throw AuthException('User not authenticated');
    }

    try {
      final data = {'status': status.toString().split('.').last};

      if (retryCount != null) {
        data['retryCount'] = retryCount as String;
      }

      await _tasksCollection.doc(taskId).update(data);
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  Stream<List<Task>> tasksStream() {
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Task.fromFirestore(data, doc.id);
          }).toList();
        });
  }
}
