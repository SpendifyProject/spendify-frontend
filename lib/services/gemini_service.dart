import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_KEY'] ?? 'NO_API_KEY';

  Future<String> generateText(
      double income, double expenses, double spendingLimit) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    String prompt =
        'Given the following financial data, provide some personalized financial tips: \nIncome: $income\nExpenses: $expenses\nSpending Limit: $spendingLimit. Do not include any headings or preambles. Just generate a paragraph containing the tip. Note that the currency is Ghanaian cedis and the tips should reflect the fact that the person is a Ghanaian. The paragraph should not be over 50 words';
    final content = [Content.text(prompt)];

    final response = await model.generateContent(content);

    return response.text ?? '';
  }
}
