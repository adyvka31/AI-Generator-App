import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String title;
  final String description;
  final String duration; // Contoh: "2 Jam"
  final String date;     // Contoh: "2024-01-28"
  final String time;     // Contoh: "14:00"
  final String status;   // 'Open', 'In Progress', 'Done'

  Ticket({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.duration,
    required this.date,
    required this.time,
    required this.status
  });

  // Konversi dari Firestore ke Object Dart
  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? '', 
      date: data['date'] ?? '',         
      time: data['time'] ?? '',         
      status: data['status'] ?? 'Open',
    );
  }

  // Konversi ke Map untuk dikirim ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}
