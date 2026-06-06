import 'package:flutter/material.dart';
import '../models/education_model.dart';

class EducationDetailScreen extends StatelessWidget {
  final EducationModel article;

  const EducationDetailScreen({super.key, required this.article});

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return '1 Day Ago';
      return '$diff Days Ago';
    } catch (_) {
      return '';
    }
  }

  IconData _iconForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'BUDGETING':
        return Icons.account_balance_wallet;
      case 'INVESTING':
        return Icons.trending_up;
      case 'HABITS':
        return Icons.savings;
      default:
        return Icons.menu_book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _parseParagraphs(article.content);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── HERO HEADER ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF2E5BFF),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFF2E5BFF), size: 20),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border,
                      color: Color(0xFF2E5BFF), size: 20),
                  onPressed: () {},
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4F7FFF), Color(0xFF2E5BFF)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Lingkaran dekoratif
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    // Icon besar di tengah
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _iconForCategory(article.category),
                              size: 52,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              article.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── KONTEN ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meta info: author + tanggal
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person,
                              color: Color(0xFF2E5BFF), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'By Miftah',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(article.createdAt),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 24),

                    // Konten artikel (diparse per blok)
                    ..._buildContentWidgets(paragraphs),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Parser konten markdown sederhana ──────────────────────
  List<_ContentBlock> _parseParagraphs(String content) {
    final lines = content.split('\n');
    final blocks = <_ContentBlock>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('## ')) {
        blocks.add(_ContentBlock(
            type: _BlockType.heading, text: trimmed.substring(3)));
      } else if (trimmed.startsWith('> ')) {
        blocks.add(_ContentBlock(
            type: _BlockType.quote, text: trimmed.substring(2)));
      } else if (trimmed.startsWith('- ')) {
        blocks.add(_ContentBlock(
            type: _BlockType.bullet, text: trimmed.substring(2)));
      } else if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
        blocks.add(_ContentBlock(
            type: _BlockType.bold,
            text: trimmed.replaceAll('**', '')));
      } else {
        blocks.add(
            _ContentBlock(type: _BlockType.paragraph, text: trimmed));
      }
    }
    return blocks;
  }

  List<Widget> _buildContentWidgets(List<_ContentBlock> blocks) {
    final widgets = <Widget>[];
    for (final block in blocks) {
      switch (block.type) {
        case _BlockType.heading:
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E5BFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      block.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;

        case _BlockType.quote:
          widgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: Color(0xFF2E5BFF), width: 3),
                ),
              ),
              child: Text(
                '"${block.text}"',
                style: const TextStyle(
                  color: Color(0xFF444466),
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
            ),
          );
          break;

        case _BlockType.bullet:
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF2E5BFF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      block.text,
                      style: const TextStyle(
                          height: 1.6,
                          fontSize: 15,
                          color: Color(0xFF333355)),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;

        case _BlockType.bold:
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 4, top: 4),
              child: Text(
                block.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          );
          break;

        case _BlockType.paragraph:
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                block.text,
                style: const TextStyle(
                  height: 1.7,
                  fontSize: 15,
                  color: Color(0xFF444466),
                ),
              ),
            ),
          );
          break;
      }
    }
    return widgets;
  }
}

enum _BlockType { heading, quote, bullet, bold, paragraph }

class _ContentBlock {
  final _BlockType type;
  final String text;
  _ContentBlock({required this.type, required this.text});
}