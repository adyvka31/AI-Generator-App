import 'package:ai_generator_app/screens/ai_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import 'ticket_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan salam berdasarkan waktu
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Mengambil nama depan dari email (jika display name kosong)
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER (Profile & Logout)
              Row(
                children: [
                  // --- SECTION KIRI: ICON PROFILE ---
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff372b2a),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, size: 20),
                      color: Colors.white,
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
                  ),

                  const SizedBox(width: 10), // Jarak pemisah
                  // --- SECTION TENGAH: NAMA USER ---
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xff372b2a),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome, ${displayName}", // Nama user
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10), // Jarak pemisah
                  // --- SECTION KANAN: LOGOUT ---
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff372b2a),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.dark_mode, size: 20, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 2. GREETING TEXT
              Text(
                "${_getGreeting()} $displayName",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400, // Tipis elegan
                  color: Color(0xff3E2723),
                ),
              ),
              const Text(
                "Manage Your Task",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3E2723),
                ),
              ),

              const SizedBox(height: 25),

              // 3. ADD TASK HERO SECTION & AI SUMMARY
              Row(
                children: [
                  // Tombol Besar: Add Task
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TicketFormScreen(ticket: null),
                        ),
                      ),
                      child: Container(
                        height: 160,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF212121,
                          ), // Hitam seperti di screenshot
                          borderRadius: BorderRadius.circular(25),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://img.freepik.com/free-photo/abstract-digital-grid-black-background_53876-97647.jpg",
                            ), // Optional Background texture
                            fit: BoxFit.cover,
                            opacity: 0.3,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            const Text(
                              "Create\nNew Task",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Card: AI Summary
                  Expanded(
                    flex: 1,
                    child: Consumer<TicketProvider>(
                      builder: (context, provider, _) {
                        return GestureDetector(
                          onTap: () {
                            // Misal mengambil data ticket pertama dari snapshot/list
                            if (tickets.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AiSummaryScreen(ticket: tickets.first),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 160,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Color(0xff372b2a)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.amber,
                                    ),
                                    if (provider.isSummarizing)
                                      const SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  "AI Summary",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Create a summary of the task you created",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchKeyword = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xff372b2a)),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 5. LIST TICKET (STREAM BUILDER)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                  decoration: const BoxDecoration(
                    color: Color(0xff372b2a), // Background wrapper gelap
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), // Sudut melengkung atas
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: StreamBuilder<List<Ticket>>(
                    stream: _firestoreService.getTickets(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      var tickets = snapshot.data ?? [];
                      if (_searchKeyword.isNotEmpty) {
                        tickets = tickets
                            .where(
                              (t) =>
                                  t.title.toLowerCase().contains(
                                    _searchKeyword.toLowerCase(),
                                  ) ||
                                  t.description.toLowerCase().contains(
                                    _searchKeyword.toLowerCase(),
                                  ),
                            )
                            .toList();
                      }

                      if (tickets.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 60,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No tasks found",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: tickets.length,
                        physics: const BouncingScrollPhysics(),
                        // Tambahkan padding bawah agar item terakhir tidak tertutup layar
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // CARD BACKGROUND: PUTIH (Kontras Terbaik)
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TicketFormScreen(ticket: ticket),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  // Status Indicator
                                  Container(
                                    width: 4,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: ticket.status == 'Done'
                                          ? Colors.green
                                          : Colors.orange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ticket.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87, // Teks Gelap
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${ticket.time} • ${ticket.date}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
