import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/firestore_service.dart';

class TicketFormScreen extends StatefulWidget {
  final Ticket? ticket;
  const TicketFormScreen({super.key, this.ticket});

  @override
  _TicketFormScreenState createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String _status = 'Open';

  // Warna Tema
  final Color _themeColor = const Color(0xff372b2a);

  @override
  void initState() {
    super.initState();
    if (widget.ticket != null) {
      _titleController.text = widget.ticket!.title;
      _descController.text = widget.ticket!.description;
      _durationController.text = widget.ticket!.duration;
      _dateController.text = widget.ticket!.date;
      _timeController.text = widget.ticket!.time;
      _status = widget.ticket!.status;
    }
  }

  // Fungsi Helper: Pilih Tanggal
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _themeColor,
              onPrimary: Colors.white,
              onSurface: _themeColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Fungsi Helper: Pilih Jam
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _themeColor,
              onPrimary: Colors.white,
              onSurface: _themeColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final service = FirestoreService();
    final newTicket = Ticket(
      id: widget.ticket?.id ?? '',
      title: _titleController.text,
      description: _descController.text,
      duration: _durationController.text,
      date: _dateController.text,
      time: _timeController.text,
      status: _status,
    );

    if (widget.ticket == null) {
      service.addTicket(newTicket);
    } else {
      service.updateTicket(newTicket);
    }
    Navigator.pop(context);
  }

  // Helper Widget untuk Label Input
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: _themeColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper Widget untuk Container Input (Pengganti OutlineInputBorder)
  InputDecoration _buildInputDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Color(0xff372b2a)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Color(0xff372b2a)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _themeColor, width: 1.5),
      ),
    );
  }

  // Wrapper Shadow untuk Input
  Widget _buildShadowContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // === 1. CUSTOM HEADER ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _themeColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Judul Halaman
                  Text(
                    widget.ticket == null ? "Create New Task" : "Edit Task",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _themeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _themeColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // === 2. FORM CONTENT ===
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE INPUT
                      _buildLabel("Task Title"),
                      _buildShadowContainer(
                        child: TextFormField(
                          controller: _titleController,
                          style: TextStyle(color: _themeColor),
                          decoration: _buildInputDecoration(
                            hint: "Enter task title...",
                          ),
                          validator: (val) =>
                              val!.isEmpty ? "Title is required" : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DESCRIPTION INPUT
                      _buildLabel("Description"),
                      _buildShadowContainer(
                        child: TextFormField(
                          controller: _descController,
                          style: TextStyle(color: _themeColor),
                          maxLines: 4,
                          decoration: _buildInputDecoration(
                            hint: "Enter task details...",
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DURATION INPUT
                      _buildLabel("Duration"),
                      _buildShadowContainer(
                        child: TextFormField(
                          controller: _durationController,
                          style: TextStyle(color: _themeColor),
                          decoration: _buildInputDecoration(
                            hint: "e.g., 2 Hours 30 Minutes",
                            suffix: Icon(
                              Icons.timer_outlined,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DATE & TIME (Row)
                      Row(
                        children: [
                          // Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Date"),
                                _buildShadowContainer(
                                  child: TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    onTap: _pickDate,
                                    style: TextStyle(color: _themeColor),
                                    decoration: _buildInputDecoration(
                                      hint: "Select Date",
                                      suffix: Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    validator: (val) =>
                                        val!.isEmpty ? "Required" : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Time"),
                                _buildShadowContainer(
                                  child: TextFormField(
                                    controller: _timeController,
                                    readOnly: true,
                                    onTap: _pickTime,
                                    style: TextStyle(color: _themeColor),
                                    decoration: _buildInputDecoration(
                                      hint: "Select Time",
                                      suffix: Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    validator: (val) =>
                                        val!.isEmpty ? "Required" : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // STATUS DROPDOWN
                      _buildLabel("Status"),
                      _buildShadowContainer(
                        child: DropdownButtonFormField<String>(
                          value: _status,
                          decoration: _buildInputDecoration(),
                          dropdownColor: Colors.white,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: _themeColor,
                          ),
                          style: TextStyle(color: _themeColor, fontSize: 16),
                          items: ['Open', 'In Progress', 'Done']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _status = val!),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColor,
                            shadowColor: _themeColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Save Task",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40), // Jarak bawah
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
