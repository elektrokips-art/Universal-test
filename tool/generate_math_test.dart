import 'dart:io';

import 'package:universal_test/models/grade_scale.dart';
import 'package:universal_test/models/question.dart';
import 'package:universal_test/models/test_recipe.dart';
import 'package:universal_test/services/excel_service.dart';

void main() {
  final questions = <Question>[
    Question(id: '1', text: '245 + 178 = ?', options: ['423', '413', '433', '343'], correctIndex: 0),
    Question(id: '2', text: '900 - 356 = ?', options: ['554', '544', '644', '536'], correctIndex: 1),
    Question(id: '3', text: '24 x 6 = ?', options: ['144', '134', '154', '124'], correctIndex: 0),
    Question(id: '4', text: '144 : 12 = ?', options: ['11', '12', '13', '14'], correctIndex: 1),
    Question(id: '5', text: "1/2 + 1/4 = ?", options: ['2/6', '1/6', '3/4', '2/4'], correctIndex: 2),
    Question(id: '6', text: "3/5 kasrini o'nlik kasrga aylantiring:", options: ['0,6', '0,3', '0,5', '0,35'], correctIndex: 0),
    Question(id: '7', text: "To'g'ri to'rtburchakning uzunligi 8 sm, eni 5 sm. Perimetri nechaga teng?", options: ['13 sm', '40 sm', '26 sm', '20 sm'], correctIndex: 2),
    Question(id: '8', text: "Tomoni 6 sm bo'lgan kvadratning yuzi nechaga teng?", options: ['24 sm2', '36 sm2', '12 sm2', '30 sm2'], correctIndex: 1),
    Question(id: '9', text: '45% ni kasr shaklida yozing:', options: ['45/1000', '4,5/100', '45/100', '450/100'], correctIndex: 2),
    Question(id: '10', text: '120 ning 25% i nechaga teng?', options: ['25', '20', '40', '30'], correctIndex: 3),
    Question(id: '11', text: 'Eng katta ikki xonali son qaysi?', options: ['90', '99', '98', '89'], correctIndex: 1),
    Question(id: '12', text: '7 ning kvadrati (7 x 7) nechaga teng?', options: ['14', '42', '49', '56'], correctIndex: 2),
    Question(id: '13', text: '100 ning kvadrat ildizi nechaga teng?', options: ['10', '50', '20', '5'], correctIndex: 0),
    Question(id: '14', text: "To'g'ri burchak necha darajaga teng?", options: ['45°', '180°', '60°', '90°'], correctIndex: 3),
    Question(id: '15', text: "Uchburchak burchaklarining yig'indisi nechaga teng?", options: ['90°', '360°', '180°', '270°'], correctIndex: 2),
    Question(id: '16', text: "3, 6, 9, 12, ... ketma-ketlikning keyingi soni qaysi?", options: ['14', '15', '16', '18'], correctIndex: 1),
    Question(id: '17', text: '2 soat 30 daqiqa jami necha daqiqa?', options: ['230', '120', '150', '180'], correctIndex: 2),
    Question(id: '18', text: '1 kilogramm necha grammga teng?', options: ['100 g', '10 000 g', '1000 g', '10 g'], correctIndex: 2),
    Question(id: '19', text: "15 sonining 1 dan tashqari eng kichik bo'luvchisi qaysi?", options: ['5', '15', '3', '7'], correctIndex: 2),
    Question(id: '20', text: '8 va 12 sonlarining eng katta umumiy bo\'luvchisi (EKUB) nechaga teng?', options: ['2', '6', '8', '4'], correctIndex: 3),
  ];

  final recipe = TestRecipe(
    id: 'math5',
    name: 'Matematika 5-sinf',
    questions: questions,
    gradeScale: const GradeScale(),
    createdAt: DateTime.now(),
  );

  final bytes = ExcelService.exportRecipe(recipe);
  File(r'G:\Universal test\Matematika_5_sinf.xlsx').writeAsBytesSync(bytes);
  // ignore: avoid_print
  print('Saved Matematika_5_sinf.xlsx with ${questions.length} questions');
}
