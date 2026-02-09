import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ticket.dart';

class FirestoreService {
  // Mengambil referensi koleksi task milik user yang sedang login
  CollectionReference get _tasksRef {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
  }

  // CRUD: Create (Add Ticket)
  Future<void> addTicket(Ticket ticket) async {
    await _tasksRef.add(ticket.toMap());
  }

  // Stream otomatis update UI jika ada perubahan data (Realtime & Offline Sync)
  Stream<List<Ticket>> getTickets() {
    return _tasksRef.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();
    });
  }

  // CRUD: Update
  Future<void> updateTicket(Ticket ticket) async {
    await _tasksRef.doc(ticket.id).update(ticket.toMap());
  }

  // CRUD: Delete
  Future<void> deleteTicket(String id) async {
    await _tasksRef.doc(id).delete();
  }
}
