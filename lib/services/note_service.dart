import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteService {
  final CollectionReference notesCollection = FirebaseFirestore.instance
      .collection("notes");

  Stream<QuerySnapshot> getUserNotes(String uid) {
    return FirebaseFirestore.instance
        .collection("notes")
        .where("userId", isEqualTo: uid)
        .snapshots();
  }

  // Add a new note
  Future<void> addNote({required String title, required String content}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await notesCollection.add({
      "title": title,
      "content": content,
      "isCompleted": false,
      "userId": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // Update an existing note
  Future<void> updateNote(String id, Map<String, dynamic> data) async {
    await notesCollection.doc(id).update(data);
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }
}
