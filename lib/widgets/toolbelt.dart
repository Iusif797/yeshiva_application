import 'package:flutter/material.dart';

class Toolbelt extends StatelessWidget {
  final int badge;
  final VoidCallback onSlova;
  final VoidCallback onNotes;
  final VoidCallback onForum;
  final VoidCallback onUpload;
  const Toolbelt({super.key, required this.badge, required this.onSlova, required this.onNotes, required this.onForum, required this.onUpload});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color.fromRGBO(16, 24, 40, 0.06), blurRadius: 16, offset: const Offset(0, 6))]),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _Item(icon: Icons.translate_rounded, label: 'Slova', badge: badge, onTap: onSlova),
        _Item(icon: Icons.note_alt_rounded, label: 'Notes', onTap: onNotes),
        _Item(icon: Icons.forum_rounded, label: 'Forum', onTap: onForum),
        _Item(icon: Icons.upload_file_rounded, label: 'Upload', onTap: onUpload),
      ]),
    );
  }
}

class _Item extends StatefulWidget {
  final IconData icon;
  final String label;
  final int? badge;
  final VoidCallback onTap;
  const _Item({required this.icon, required this.label, required this.onTap, this.badge});
  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> with SingleTickerProviderStateMixin {
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.96),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: 72,
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.08), shape: BoxShape.circle),
                  child: Icon(widget.icon, size: 28),
                ),
                if ((widget.badge ?? 0) > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(999)),
                      child: Text('${widget.badge}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
              ]),
              const SizedBox(height: 6),
              Text(widget.label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}


