import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_provider.dart';
import '../models/submission.dart';
import '../models/test_recipe.dart';
import '../services/pdf_service.dart';
import '../services/test_server.dart';

class SessionScreen extends StatefulWidget {
  final TestRecipe recipe;
  const SessionScreen({super.key, required this.recipe});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final TestServer _server = TestServer();
  StreamSubscription<Submission>? _sub;
  String? _url;
  bool _starting = true;
  String? _error;
  final List<Submission> _submissions = [];

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final locale = context.read<LocaleProvider>();
      final lang = locale.language == AppLanguage.uz ? 'uz' : 'ru';
      final ip = await _server.start(widget.recipe, lang: lang);
      _sub = _server.onSubmission.listen((s) {
        setState(() => _submissions.add(s));
      });
      // Keep the screen on for the whole session — if it locks, Android
      // freezes the app's background work and the local server drops.
      await WakelockPlus.enable();
      setState(() {
        _url = ip != null ? 'http://$ip:${TestServer.port}' : null;
        _starting = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _starting = false;
      });
    }
  }

  bool _stopping = false;

  Future<void> _handleStop() async {
    if (_stopping) return;
    _stopping = true;
    await _sub?.cancel();
    await _server.stop();
    await WakelockPlus.disable();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _sub?.cancel();
    // Best-effort fallback in case the screen was left some other way
    // (e.g. system back gesture) without going through _handleStop.
    _server.stop();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: locale.t('stopSession'),
          onPressed: _handleStop,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            tooltip: locale.t('stopSession'),
            onPressed: _handleStop,
            icon: const Icon(Icons.stop_circle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submissions.isEmpty
            ? null
            : () => PdfService.generateAndShare(
                  recipe: widget.recipe,
                  submissions: _submissions,
                  lang: locale.language,
                ),
        icon: const Icon(Icons.picture_as_pdf),
        label: Text(locale.t('generatePdf')),
      ),
      body: _starting
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_url != null) ...[
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: QrImageView(
                            data: _url!,
                            size: 220,
                            version: QrVersions.auto,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '${locale.t('ipAddress')}: $_url',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          locale.t('scanQr'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber, width: 0.7),
                        ),
                        child: Text(
                          locale.t('chromeWarningHint'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ] else
                      Center(child: Text(locale.t('ipAddress'))),
                    const Divider(height: 32),
                    Text(
                      '${locale.t('submissions')} (${_submissions.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_submissions.isEmpty)
                      Text(locale.t('noSubmissionsYet'))
                    else
                      ..._submissions.map((s) => Card(
                            child: ListTile(
                              title: Text(s.fio),
                              subtitle: Text('${locale.t('studentClass')}: ${s.studentClass}'),
                              trailing: Text(
                                '${s.correctCount}/${s.totalQuestions} → ${s.grade}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                  ],
                ),
    );
  }
}
