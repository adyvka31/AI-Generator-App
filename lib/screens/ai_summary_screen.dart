// lib/screens/ai_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';

class AiSummaryScreen extends StatefulWidget {
  final List<Ticket> allTickets; // Terima daftar semua task

  const AiSummaryScreen({super.key, required this.allTickets});

  @override
  State<AiSummaryScreen> createState() => _AiSummaryScreenState();
}

class _AiSummaryScreenState extends State<AiSummaryScreen> {
  Ticket? selectedTicket;
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        title: const Text(
          "AI Task Assistant",
          style: TextStyle(
            color: Color(0xff3E2723),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff3E2723)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Pilih Task
            const Text(
              "Pilih Task:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Ticket>(
                  isExpanded: true,
                  hint: const Text("Pilih salah satu task"),
                  value: selectedTicket,
                  items: widget.allTickets.map((Ticket t) {
                    return DropdownMenuItem<Ticket>(
                      value: t,
                      child: Text(t.title),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedTicket = val),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Input Prompt
            const Text(
              "Instruksi Prompt (Opsional):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: "Contoh: Buatkan poin-poin penting...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 15),

            // 3. Tombol Generate
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTicket == null
                    ? null
                    : () {
                        context.read<TicketProvider>().getAiSummary(
                          selectedTicket!.title,
                          selectedTicket!.description,
                          userPrompt: _promptController.text,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff372B2A),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Generate with Gemini AI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4. Output Jawaban AI
            const Text(
              "AI Response:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Consumer<TicketProvider>(
              builder: (context, provider, _) {
                if (provider.isSummarizing) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff6F4E37)),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xff372B2A).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    provider.summary.isEmpty
                        ? "Belum ada hasil."
                        : provider.summary,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
