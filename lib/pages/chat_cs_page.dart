import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class ChatCsPage extends StatefulWidget {
  const ChatCsPage({super.key});

  @override
  State<ChatCsPage> createState() => _ChatCsPageState();
}

class _ChatCsPageState extends State<ChatCsPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Riwayat pesan awal sesuai desain asli pada screenshot
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Halo! Selamat datang di LET’S PAY.\nAda yang bisa kami bantu hari ini?',
      isUser: false,
      time: '09.41',
    ),
    _ChatMessage(
      text: 'Halo, saya ingin bertanya tentang status transaksi saya.',
      isUser: true,
      time: '09.42',
    ),
    _ChatMessage(
      text: 'Tentu, kami bantu cek ya. Silakan kirim ID transaksi dari riwayat transaksi di aplikasi.',
      isUser: false,
      time: '09.42',
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isUser: true,
          time: timeStr,
        ),
      );
    });

    _textController.clear();
    _scrollToBottom();

    // Simulasi respons otomatis dari CS lokal setelah jeda 1 detik
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final replyNow = DateTime.now();
      final replyTime =
          '${replyNow.hour.toString().padLeft(2, '0')}.${replyNow.minute.toString().padLeft(2, '0')}';

      String replyText;
      final lower = text.toLowerCase();
      if (lower.contains('terima kasih') || lower.contains('makasih')) {
        replyText =
            'Sama-sama! Senang bisa membantu Anda di LET’S PAY. Ada hal lain yang bisa kami bantu?';
      } else if (lower.contains('id') ||
          lower.contains('trx') ||
          lower.contains('transaksi')) {
        replyText =
            '(Simulasi CS): Terima kasih atas informasinya. Kami sedang memproses pengecekan status transaksi Anda.';
      } else {
        replyText =
            '(Simulasi CS): Pesan Anda telah kami terima. Tim kami akan segera meninjau pertanyaan Anda.';
      }

      setState(() {
        _messages.add(
          _ChatMessage(
            text: replyText,
            isUser: false,
            time: replyTime,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Background Gradient Persis Sesuai Desain
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B7CD4), // Biru atas
                  Color(0xFF8B88CA),
                  Color(0xFFA796C4),
                  Color(0xFFBF9FBD), // Mauve / Lilac bawah
                ],
                stops: [0.0, 0.32, 0.68, 1.0],
              ),
            ),
          ),

          // 2. Lingkaran Ambient Kanan Atas
          Positioned(
            top: size.height * 0.22,
            right: -size.width * 0.22,
            child: Container(
              width: size.width * 0.70,
              height: size.width * 0.70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),

          // 3. Lingkaran Ambient Kiri Tengah
          Positioned(
            top: size.height * 0.50,
            left: -size.width * 0.28,
            child: Container(
              width: size.width * 0.75,
              height: size.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // 4. Konten Chat Utama
          SafeArea(
            child: Column(
              children: [
                // Header & Profil CS (Fixed di bagian atas)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Tombol Kembali (Panah Kiri)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // Header: "LET’S PAY" (Warna Biru Gelap Pekat)
                      Text(
                        'LET’S PAY',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1C2487),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Sub-header: "Chat dengan CS"
                      Text(
                        'Chat dengan CS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Deskripsi
                      Text(
                        'Sampaikan pertanyaanmu.\nTim kami siap membantu.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.95),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Kartu Profil CS LET’S PAY (Frosted Glass Pill)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBD9FC6).withValues(alpha: 0.40),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CS LET’S PAY',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'Terhubung dengan customer service',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white
                                                .withValues(alpha: 0.90),
                                          ),
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

                      const SizedBox(height: 14),

                      // Badge Tanggal: "Hari ini"
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFBD9FC6).withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Hari ini',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // Area Pesan Percakapan (Scrollable)
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: msg.isUser
                            ? _buildUserBubble(msg, size)
                            : _buildCsBubble(msg, size),
                      );
                    },
                  ),
                ),

                // Kolom Input Pesan di Bagian Bawah Layar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBD9FC6).withValues(alpha: 0.45),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(22)),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.40),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Input Teks
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _textController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: const Color(0xFF2C3246),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan di sini...',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 11),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Tombol Kirim Pesan
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _sendMessage,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C41B0), // Biru pekat
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF102766)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bubble Chat CS (Sisi Kiri, Warna Putih)
  Widget _buildCsBubble(_ChatMessage msg, Size size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * 0.74),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF2C3246),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                msg.time,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bubble Chat Pengguna (Sisi Kanan, Warna Biru Solid)
  Widget _buildUserBubble(_ChatMessage msg, Size size) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * 0.74),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C41B0),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF102766).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
