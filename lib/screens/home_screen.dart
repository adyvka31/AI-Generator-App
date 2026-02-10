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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      // Membungkus dengan StreamBuilder di level atas agar variabel 'allTickets' bisa diakses di mana saja
      body: StreamBuilder<List<Ticket>>(
        stream: _firestoreService.getTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff372b2a)),
            );
          }

          final allTickets = snapshot.data ?? [];

          // Filter untuk ListView berdasarkan search bar
          final filteredTickets = allTickets.where((t) {
            final keyword = _searchKeyword.toLowerCase();
            return t.title.toLowerCase().contains(keyword) ||
                t.description.toLowerCase().contains(keyword);
          }).toList();

          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. HEADER (Profile & Logout) ---
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xff372b2a),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff372b2a),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Welcome, $displayName",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xff372b2a),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.dark_mode,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- 2. GREETING TEXT ---
                  Text(
                    "${_getGreeting()} $displayName",
                    style: const TextStyle(
                      fontSize: 28,
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

                  // --- 3. HERO SECTION (Add Task & AI Summary) ---
                  Row(
                    children: [
                      // Tombol Create New Task
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const TicketFormScreen(ticket: null),
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
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
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

                      // Tombol AI Summary (Menggunakan allTickets yang sudah di-fetch)
                      Expanded(
                        child: Consumer<TicketProvider>(
                          builder: (context, provider, _) {
                            return GestureDetector(
                              onTap: () {
                                if (allTickets.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AiSummaryScreen(
                                        allTickets: allTickets,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Belum ada task untuk diringkas",
                                      ),
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
                                  border: Border.all(
                                    color: const Color(0xff372b2a),
                                  ),
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
                                      "AI Assistant",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Summarize and chat with Gemini",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                    ),
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

                  // --- 4. SEARCH BAR ---
                  TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _searchKeyword = value),
                    decoration: InputDecoration(
                      hintText: "Search tasks...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Color(0xff372b2a)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- 5. LIST TICKET ---
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 24,
                        right: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xff372b2a),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: filteredTickets.isEmpty
                          ? const Center(
                              child: Text(
                                "No tasks found",
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredTickets.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 20),
                              itemBuilder: (context, index) {
                                final ticket = filteredTickets[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TicketFormScreen(ticket: ticket),
                                      ),
                                    ),
                                    leading: Container(
                                      width: 4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ticket.status == 'Done'
                                            ? Colors.green
                                            : Colors.orange,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    title: Text(
                                      ticket.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${ticket.time} • ${ticket.date}",
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
