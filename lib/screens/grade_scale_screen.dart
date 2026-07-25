import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/locale_provider.dart';
import '../models/grade_scale.dart';

class GradeScaleScreen extends StatefulWidget {
  final GradeScale initial;
  const GradeScaleScreen({super.key, required this.initial});

  @override
  State<GradeScaleScreen> createState() => _GradeScaleScreenState();
}

class _GradeScaleScreenState extends State<GradeScaleScreen> {
  late final TextEditingController _c5from;
  late final TextEditingController _c5to;
  late final TextEditingController _c4from;
  late final TextEditingController _c4to;
  late final TextEditingController _c3from;
  late final TextEditingController _c3to;
  late final TextEditingController _c2from;
  late final TextEditingController _c2to;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _c5from = TextEditingController(text: '${s.grade5From}');
    _c5to = TextEditingController(text: '${s.grade5To}');
    _c4from = TextEditingController(text: '${s.grade4From}');
    _c4to = TextEditingController(text: '${s.grade4To}');
    _c3from = TextEditingController(text: '${s.grade3From}');
    _c3to = TextEditingController(text: '${s.grade3To}');
    _c2from = TextEditingController(text: '${s.grade2From}');
    _c2to = TextEditingController(text: '${s.grade2To}');
  }

  @override
  void dispose() {
    for (final c in [_c5from, _c5to, _c4from, _c4to, _c3from, _c3to, _c2from, _c2to]) {
      c.dispose();
    }
    super.dispose();
  }

  int _n(TextEditingController c, int fallback) => int.tryParse(c.text) ?? fallback;

  void _save() {
    final s = widget.initial;
    Navigator.of(context).pop(GradeScale(
      grade5From: _n(_c5from, s.grade5From),
      grade5To: _n(_c5to, s.grade5To),
      grade4From: _n(_c4from, s.grade4From),
      grade4To: _n(_c4to, s.grade4To),
      grade3From: _n(_c3from, s.grade3From),
      grade3To: _n(_c3to, s.grade3To),
      grade2From: _n(_c2from, s.grade2From),
      grade2To: _n(_c2to, s.grade2To),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.t('gradeScale')),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.check)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GradeRow(label: locale.t('grade5'), from: _c5from, to: _c5to),
          _GradeRow(label: locale.t('grade4'), from: _c4from, to: _c4to),
          _GradeRow(label: locale.t('grade3'), from: _c3from, to: _c3to),
          _GradeRow(label: locale.t('grade2'), from: _c2from, to: _c2to),
        ],
      ),
    );
  }
}

class _GradeRow extends StatelessWidget {
  final String label;
  final TextEditingController from;
  final TextEditingController to;
  const _GradeRow({required this.label, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: from,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: locale.t('from'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: to,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: locale.t('to'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
