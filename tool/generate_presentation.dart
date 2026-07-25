import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Colors matching the real app theme.
const kBlue = PdfColor.fromInt(0xFF2F6FEB);
const kDark = PdfColor.fromInt(0xFF14161C);
const kDarkCard = PdfColor.fromInt(0xFF1E212B);
const kGreen = PdfColor.fromInt(0xFF2E9E5B);
const kGrey = PdfColor.fromInt(0xFF8A8F98);
const kRed = PdfColor.fromInt(0xFFE0483E);
const kTransparent = PdfColor(0, 0, 0, 0);

late pw.Font kRegular;
late pw.Font kBold;

Future<void> main() async {
  final regularBytes = await File(r'assets\fonts\Arial-Regular.ttf').readAsBytes();
  final boldBytes = await File(r'assets\fonts\Arial-Bold.ttf').readAsBytes();
  kRegular = pw.Font.ttf(ByteData.sublistView(regularBytes));
  kBold = pw.Font.ttf(ByteData.sublistView(boldBytes));

  final logoBytes = await File(r'assets\icon\icon.png').readAsBytes();
  final logoImage = pw.MemoryImage(logoBytes);

  final doc = pw.Document(theme: pw.ThemeData.withFont(base: kRegular, bold: kBold));

  doc.addPage(_titleSlide(logoImage));
  doc.addPage(_aiSlide());
  doc.addPage(_creationSlide());
  doc.addPage(_excelSlide());
  doc.addPage(_gradeScaleSlide());
  doc.addPage(_sessionSlide());
  doc.addPage(_studentSlide());
  doc.addPage(_pdfSlide());
  doc.addPage(_themeLangSlide());
  doc.addPage(_summarySlide());

  final bytes = await doc.save();
  await File(r'G:\Universal test\Universal_Test_Presentation.pdf').writeAsBytes(bytes);
  // ignore: avoid_print
  print('Saved presentation PDF');
}

pw.Page _slide({
  required String badge,
  required String title,
  required String subtitle,
  required pw.Widget mockup,
  required List<String> bullets,
  PdfColor badgeColor = kBlue,
}) {
  return pw.Page(
    pageFormat: PdfPageFormat.a4.landscape,
    margin: const pw.EdgeInsets.all(0),
    build: (context) => pw.Container(
      color: PdfColors.white,
      padding: const pw.EdgeInsets.fromLTRB(40, 32, 40, 32),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: pw.BoxDecoration(
                  color: badgeColor,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(badge,
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 11, font: kBold)),
              ),
            ],
          ),
          pw.SizedBox(height: 14),
          pw.Text(title, style: pw.TextStyle(fontSize: 28, font: kBold)),
          pw.SizedBox(height: 6),
          pw.Text(subtitle, style: const pw.TextStyle(fontSize: 13, color: kGrey)),
          pw.SizedBox(height: 22),
          pw.Expanded(
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(flex: 5, child: pw.Center(child: mockup)),
                pw.SizedBox(width: 30),
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      for (final b in bullets)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 14),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                margin: const pw.EdgeInsets.only(top: 4, right: 10),
                                width: 7,
                                height: 7,
                                decoration: const pw.BoxDecoration(
                                  color: kBlue,
                                  shape: pw.BoxShape.circle,
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(b, style: const pw.TextStyle(fontSize: 12.5)),
                              ),
                            ],
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
    ),
  );
}

// ---------- Mockup helpers (recreate real app UI, not raw screenshots) ----------

pw.Widget _phoneFrame({required pw.Widget child, bool dark = true, double width = 300, double height = 430}) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      color: PdfColors.grey900,
      borderRadius: pw.BorderRadius.circular(26),
    ),
    child: pw.Container(
      decoration: pw.BoxDecoration(
        color: dark ? kDark : PdfColors.white,
        borderRadius: pw.BorderRadius.circular(18),
      ),
      padding: const pw.EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: child,
    ),
  );
}

pw.Widget _appBarRow(String title, {bool dark = true}) => pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                fontSize: 15, font: kBold, color: dark ? PdfColors.white : PdfColors.black)),
        pw.Row(children: [
          _pillDot(dark),
          pw.SizedBox(width: 6),
          _pillDot(dark),
        ]),
      ],
    );

pw.Widget _pillDot(bool dark) => pw.Container(
      width: 16,
      height: 16,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: dark ? PdfColors.grey700 : PdfColors.grey300,
      ),
    );

pw.Widget _fieldMock(String label, {bool dark = true}) => pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: dark ? PdfColors.grey700 : PdfColors.grey400, width: 0.7),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(label,
          style: pw.TextStyle(fontSize: 9.5, color: dark ? PdfColors.grey500 : kGrey)),
    );

pw.Widget _buttonMock(String label, {PdfColor color = kBlue, bool outline = false}) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: outline ? kTransparent : color,
        border: outline ? pw.Border.all(color: color, width: 1) : null,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Text(label,
          style: pw.TextStyle(
              fontSize: 9, font: kBold, color: outline ? color : PdfColors.white)),
    );

pw.Widget _checkbox(bool checked) => pw.Container(
      width: 14,
      height: 14,
      decoration: pw.BoxDecoration(
        color: checked ? kBlue : kTransparent,
        border: pw.Border.all(color: checked ? kBlue : PdfColors.grey600, width: 1),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: checked
          ? pw.Center(
              child: pw.Text('v', style: const pw.TextStyle(fontSize: 8, color: PdfColors.white)))
          : null,
    );

// ---------- Slides (Uzbek — matches the app's current interface language) ----------

pw.Page _titleSlide(pw.MemoryImage logo) => pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => pw.Container(
        color: kDark,
        child: pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                width: 110,
                height: 110,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(26),
                  image: pw.DecorationImage(image: logo, fit: pw.BoxFit.cover),
                ),
              ),
              pw.SizedBox(height: 26),
              pw.Text('Universal Test',
                  style: pw.TextStyle(fontSize: 40, font: kBold, color: PdfColors.white)),
              pw.SizedBox(height: 10),
              pw.Text(
                "Maktab, kollej va OTMlar uchun oflayn testlash — istalgan savol, istalgan mavzu — Wi-Fi tarmoq + QR-kod, internetsiz va serversiz",
                style: const pw.TextStyle(fontSize: 14, color: kGrey),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 26),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  _tag('RU / UZ'),
                  pw.SizedBox(width: 10),
                  _tag('AI generatsiya'),
                  pw.SizedBox(width: 10),
                  _tag('Excel'),
                  pw.SizedBox(width: 10),
                  _tag('PDF hisobot'),
                ],
              ),
            ],
          ),
        ),
      ),
    );

pw.Widget _tag(String text) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: pw.BoxDecoration(
        color: kDarkCard,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: PdfColors.grey800, width: 0.5),
      ),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
    );

pw.Page _aiSlide() => _slide(
      badge: 'ASOSIY FUNKSIYA',
      badgeColor: kGreen,
      title: 'AI savol generatori',
      subtitle: "Test yaratish ekranidagi «AI bilan yaratish» oynasi",
      mockup: _phoneFrame(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _appBarRow('Yangi test'),
            pw.SizedBox(height: 16),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: kDarkCard,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('AI bilan yaratish',
                      style: pw.TextStyle(color: PdfColors.white, fontSize: 12, font: kBold)),
                  pw.SizedBox(height: 10),
                  _fieldMock('Test mavzusi: Matematika 5-sinf'),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Savollar soni', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500))),
                    pw.Text('20', style: pw.TextStyle(fontSize: 9, color: PdfColors.white, font: kBold)),
                  ]),
                  pw.SizedBox(height: 6),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Javob variantlari', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500))),
                    pw.Text('4', style: pw.TextStyle(fontSize: 9, color: PdfColors.white, font: kBold)),
                  ]),
                  pw.SizedBox(height: 14),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      _buttonMock('Bekor qilish', outline: true, color: PdfColors.grey400),
                      pw.SizedBox(width: 8),
                      _buttonMock('Yaratish', color: kGreen),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bullets: const [
        "O'qituvchi mavzuni kiritadi («Matematika 5-sinf», «O'zbekiston tarixi» — istalgan narsa) — AI savollarni, javob variantlarini yozadi va to'g'risini belgilaydi.",
        "OpenRouter orqali — bitta kalit, model tanlash: DeepSeek, Gemini, GPT va boshqalar, jumladan bepul (:free) versiyalar.",
        "Generatsiya interfeys tilida (rus yoki o'zbek) bo'ladi va darhol testdagi bo'sh joylarni to'ldiradi.",
        "Internet faqat shu bosqichda kerak — darsning o'zi sinfda to'liq oflayn o'tadi.",
      ],
    );

pw.Page _creationSlide() => _slide(
      badge: 'TEST YARATISH',
      title: 'Savollar konstruktori',
      subtitle: "30 tagacha savol, moslashuvchan javoblar soni, o'chirmasdan yoqish/o'chirish",
      mockup: _phoneFrame(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _appBarRow('Tahrirlash'),
            pw.SizedBox(height: 14),
            for (final n in [1, 2])
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: kDarkCard,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      pw.Container(
                        width: 18, height: 18,
                        decoration: const pw.BoxDecoration(color: kBlue, shape: pw.BoxShape.circle),
                        child: pw.Center(child: pw.Text('$n', style: pw.TextStyle(fontSize: 8, color: PdfColors.white, font: kBold))),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(child: _fieldMock('Savol $n')),
                      pw.SizedBox(width: 6),
                      _checkbox(true),
                    ]),
                    pw.SizedBox(height: 4),
                    for (var i = 0; i < 3; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Row(children: [
                          _checkbox(i == 0),
                          pw.SizedBox(width: 6),
                          pw.Expanded(child: _fieldMock('Javob ${i + 1}')),
                        ]),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bullets: const [
        "Har bir testda 30 tagacha savol, har savolda 2 dan 5 tagacha javob varianti — istalgan mavzu uchun.",
        "Har bir savol yonida «yoqilgan» chekboksi — savolni o'chirmasdan testdan vaqtincha chiqarib qo'yish mumkin (kamida 10 tasi faol bo'lishi kerak).",
        "Har bir test uchun alohida 5/4/3/2 baholash shkalasi.",
        "Tayyor test «retsept» sifatida saqlanadi — qayta yaratmasdan bir zumda ishga tushiriladi.",
      ],
    );

pw.Page _excelSlide() => _slide(
      badge: 'OMMAVIY TAYYORLASH',
      title: 'Excel orqali import va eksport',
      subtitle: "Savollarni paketlar bilan tayyorlang yoki testlarni o'qituvchilar bilan almashing",
      mockup: pw.Container(
        width: 340,
        padding: const pw.EdgeInsets.all(18),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300, width: 1),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Row(children: [
                pw.Text('№', style: pw.TextStyle(font: kBold, fontSize: 9)),
                pw.SizedBox(width: 14),
                pw.Text('Savol', style: pw.TextStyle(font: kBold, fontSize: 9)),
                pw.Spacer(),
                pw.Text("To'g'ri №", style: pw.TextStyle(font: kBold, fontSize: 9)),
              ]),
            ),
            pw.Divider(color: PdfColors.grey400, thickness: 0.6),
            for (final row in [
              ['1', '245 + 178 = ?', '1'],
              ['2', '900 - 356 = ?', '2'],
              ['3', "To'g'ri burchak necha daraja?", '4'],
            ])
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(children: [
                  pw.Text(row[0], style: const pw.TextStyle(fontSize: 8.5)),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: pw.Text(row[1], style: const pw.TextStyle(fontSize: 8.5))),
                  pw.Text(row[2], style: const pw.TextStyle(fontSize: 8.5)),
                ]),
              ),
            pw.SizedBox(height: 14),
            pw.Row(children: [
              _buttonMock('Excel ga eksport'),
              pw.SizedBox(width: 8),
              _buttonMock('Excel dan import', color: kGreen),
            ]),
          ],
        ),
      ),
      bullets: const [
        "Testni .xlsx formatida eksport qilish — savollar, variantlar, to'g'ri javoblar va baholash shkalasi ikkita varaqda.",
        "Faylni qayta import qilish — barcha sozlamalari bilan butun test bitta fayldan yaratiladi.",
        "Savollarni ilova tashqarisida (Excel/Google Sheets) tayyorlab, paketlar bilan yuklash qulay.",
        "Haqiqiy testda tekshirildi: «Matematika 5-sinf» — 20 ta savol, to'liq aylanma: eksport → import → seans.",
      ],
    );

pw.Page _gradeScaleSlide() => _slide(
      badge: 'BAHOLASH',
      title: 'Moslashuvchan baholash shkalasi',
      subtitle: "Har bir baho uchun to'g'ri javoblar oralig'i — har bir test uchun alohida",
      mockup: pw.Container(
        width: 320,
        child: pw.Column(
          children: [
            for (final row in [
              ['Baho 5', '18', '20', kGreen],
              ['Baho 4', '14', '17', kBlue],
              ['Baho 3', '10', '13', PdfColor.fromInt(0xFFCB8A1E)],
              ['Baho 2', '0', '9', kRed],
            ])
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border(left: pw.BorderSide(color: row[3] as PdfColor, width: 4)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(row[0] as String, style: pw.TextStyle(font: kBold, fontSize: 11)),
                    pw.Text("${row[1]} dan ${row[2]} gacha to'g'ri",
                        style: const pw.TextStyle(fontSize: 10, color: kGrey)),
                  ],
                ),
              ),
          ],
        ),
      ),
      bullets: const [
        "O'qituvchi har bir baho uchun to'g'ri javoblar sonining «dan — gacha» chegarasini o'zi belgilaydi.",
        "O'quvchi natijasi shu shkala bo'yicha avtomatik bahoga aylantiriladi.",
        "Har xil testlar — har xil shkalalar (masalan, 30 va 10 savolli testlar boshqacha hisoblanadi).",
        "Topshirganlar ro'yxatida va yakuniy PDF hisobotda ham ishlatiladi.",
      ],
    );

pw.Page _sessionSlide() => _slide(
      badge: 'OFLAYN ARXITEKTURA',
      title: 'Wi-Fi tarmoq + QR-kod',
      subtitle: "O'qituvchi telefoni = tarmoq nuqtasi va server — internet kerak emas",
      mockup: _phoneFrame(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _appBarRow('Matematika 5-sinf'),
            pw.SizedBox(height: 16),
            pw.Center(child: _qrMock()),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text('Manzil: http://192.168.80.1:8080',
                  style: pw.TextStyle(color: PdfColors.white, fontSize: 9, font: kBold)),
            ),
            pw.SizedBox(height: 14),
            pw.Text('Topshirganlar (1)',
                style: pw.TextStyle(color: PdfColors.white, fontSize: 10, font: kBold)),
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(color: kDarkCard, borderRadius: pw.BorderRadius.circular(8)),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Alisher Karimov', style: const pw.TextStyle(fontSize: 9, color: PdfColors.white)),
                  pw.Text('17/20 -> 4', style: pw.TextStyle(fontSize: 9, color: kGreen, font: kBold)),
                ],
              ),
            ),
          ],
        ),
      ),
      bullets: const [
        "O'qituvchi o'z telefonida tarmoq nuqtasini yoqadi — oddiy mobil hotspot kabi.",
        "Ilova lokal serverni ishga tushiradi va testga havola bo'lgan QR-kodni ko'rsatadi.",
        "O'quvchilar QR-kodni kamera bilan skanerlaydi — test ularning telefon brauzerida ochiladi.",
        "Natijalar o'qituvchida real vaqtda ko'rinadi — internet orqali bitta bayt ham o'tmaydi.",
      ],
    );

pw.Widget _qrMock() {
  final rnd = Random(7);
  const cells = 11;
  const cellSize = 8.0;
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    color: PdfColors.white,
    child: pw.SizedBox(
      width: cells * cellSize,
      height: cells * cellSize,
      child: pw.Stack(
        children: [
          for (var r = 0; r < cells; r++)
            for (var c = 0; c < cells; c++)
              if (_qrIsCorner(r, c, cells) || rnd.nextBool())
                pw.Positioned(
                  left: c * cellSize,
                  top: r * cellSize,
                  child: pw.Container(
                    width: cellSize,
                    height: cellSize,
                    color: _qrIsCorner(r, c, cells) ? PdfColors.black : PdfColors.grey900,
                  ),
                ),
        ],
      ),
    ),
  );
}

bool _qrIsCorner(int r, int c, int cells) {
  bool inBlock(int rr, int cc) => r >= rr && r < rr + 3 && c >= cc && c < cc + 3;
  return inBlock(0, 0) || inBlock(0, cells - 3) || inBlock(cells - 3, 0);
}

pw.Page _studentSlide() => _slide(
      badge: "O'QUVCHI TOMONI",
      title: 'Brauzerda testni topshirish',
      subtitle: "O'quvchiga hech qanday ilova o'rnatish shart emas",
      mockup: pw.Container(
        width: 340,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const pw.BoxDecoration(
                color: kBlue,
                borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(9), topRight: pw.Radius.circular(9)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Universal Test', style: pw.TextStyle(color: PdfColors.white, fontSize: 10, font: kBold)),
                  pw.Row(children: [_tagSmall('RU'), pw.SizedBox(width: 4), _tagSmall('UZ', active: true)]),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(14),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _fieldMock('Familiya Ism: Alisher Karimov', dark: false),
                  _fieldMock('Sinf: 5-A', dark: false),
                  pw.SizedBox(height: 6),
                  pw.Center(child: _buttonMock('Testni boshlash')),
                  pw.Divider(color: PdfColors.grey300, height: 20),
                  pw.Text('1. 245 + 178 = ?', style: pw.TextStyle(fontSize: 9.5, font: kBold)),
                  pw.SizedBox(height: 4),
                  for (final opt in ['423', '413', '433', '343'])
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Row(children: [
                        pw.Container(width: 9, height: 9, decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, border: pw.Border.all(color: PdfColors.grey500, width: 0.8), color: opt == '423' ? kBlue : PdfColors.white)),
                        pw.SizedBox(width: 6),
                        pw.Text(opt, style: const pw.TextStyle(fontSize: 8.5)),
                      ]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bullets: const [
        "QR-kodni skanerlaydi — oddiy veb-sahifa ochiladi, telefonning istalgan brauzerida ishlaydi.",
        "Tepada — Familiya Ism va Sinf, keyinchalik natijalarni bitta hisobotga yig'ish uchun.",
        "Interfeys ikki tilda (rus/o'zbek), til almashtirgich to'g'ridan-to'g'ri sahifada.",
        "Bitta «Yuborish» bosilishi bilan natija darhol lokal tarmoq orqali o'qituvchiga boradi.",
      ],
    );

pw.Widget _tagSmall(String t, {bool active = false}) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: pw.BoxDecoration(
        color: active ? PdfColors.white : kTransparent,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(t,
          style: pw.TextStyle(
              fontSize: 7, font: kBold, color: active ? kBlue : PdfColors.white)),
    );

pw.Page _pdfSlide() => _slide(
      badge: 'HISOBOT',
      title: 'Bir tugma bilan PDF hisobot',
      subtitle: "Jurnal uchun tayyor ro'yxat — ballarni qo'lda hisoblash shart emas",
      mockup: pw.Container(
        width: 340,
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(10)),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Matematika 5-sinf', style: pw.TextStyle(fontSize: 15, font: kBold)),
            pw.SizedBox(height: 4),
            pw.Text('Sana: 2026-07-25 09:06', style: const pw.TextStyle(fontSize: 8, color: kGrey)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _tCell('Familiya Ism', bold: true),
                    _tCell('Sinf', bold: true),
                    _tCell("To'g'ri", bold: true),
                    _tCell('Baho', bold: true),
                  ],
                ),
                pw.TableRow(children: [
                  _tCell('Alisher Karimov'),
                  _tCell('5-A'),
                  _tCell('17/20'),
                  _tCell('4'),
                ]),
              ],
            ),
          ],
        ),
      ),
      bullets: const [
        "Seans ekranidagi «PDF shakllantirish» tugmasi — topshirgan barcha o'quvchilar ballari va baholari bilan.",
        "Kirill va lotin yozuvi to'g'ri ko'rsatiladi (o'rnatilgan shrift).",
        "Natija darhol chop etish yoki umumiy chat/jurnalga yuborishga tayyor.",
        "Haqiqiy sinovda tekshirildi: Alisher Karimov, 5-A, 17/20 -> baho 4.",
      ],
    );

pw.Widget _tCell(String t, {bool bold = false}) => pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(t, style: pw.TextStyle(fontSize: 9, font: bold ? kBold : kRegular)),
    );

pw.Page _themeLangSlide() => _slide(
      badge: 'QULAYLIK',
      title: "Ikki til, yorug' va qorong'i mavzu",
      subtitle: "O'qituvchiga qulay bo'lganicha moslashadi",
      mockup: pw.Row(
        children: [
          _phoneFrame(
            width: 150,
            height: 220,
            dark: false,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Mening testlarim', style: pw.TextStyle(fontSize: 11, font: kBold, color: PdfColors.black)),
                pw.SizedBox(height: 10),
                pw.Container(height: 50, decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8))),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          _phoneFrame(
            width: 150,
            height: 220,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Mening testlarim', style: pw.TextStyle(fontSize: 10.5, font: kBold, color: PdfColors.white)),
                pw.SizedBox(height: 10),
                pw.Container(height: 50, decoration: pw.BoxDecoration(color: kDarkCard, borderRadius: pw.BorderRadius.circular(8))),
              ],
            ),
          ),
        ],
      ),
      bullets: const [
        "O'qituvchi interfeysi va o'quvchi sahifasi — rus va o'zbek tillarida.",
        "Yorug'/qorong'i mavzu almashtirgichi — tanlov ilova qayta ishga tushirilganda ham saqlanadi.",
        "Bitta testni interfeys tili har xil bo'lgan o'quvchilar bemalol topshira oladi.",
      ],
    );

pw.Page _summarySlide() => pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => pw.Container(
        color: kDark,
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Xulosa', style: pw.TextStyle(fontSize: 30, font: kBold, color: PdfColors.white)),
            pw.SizedBox(height: 20),
            for (final f in [
              "AI orqali mavzu bo'yicha savollar generatsiyasi (OpenRouter: DeepSeek / Gemini va boshqalar)",
              "Test konstruktori — 30 tagacha savol, yoqish/o'chirish, qayta ishga tushirish uchun retseptlar",
              "Testlarni Excel orqali eksport / import qilish",
              "Moslashuvchan 5-4-3-2 baholash shkalasi",
              "To'liq oflayn: o'qituvchi Wi-Fi tarmog'i + QR-kod, server va internetsiz",
              "O'quvchi oddiy brauzerida, 2 tilda testni topshirish",
              "Sinf bo'yicha tayyor PDF hisobot bitta tugma bilan",
              "Yorug' / qorong'i mavzu",
            ])
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Text(f, style: const pw.TextStyle(fontSize: 14, color: PdfColors.white)),
              ),
          ],
        ),
      ),
    );
