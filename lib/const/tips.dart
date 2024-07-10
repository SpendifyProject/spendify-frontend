import 'dart:math';

import 'package:flutter/material.dart';

List<String> tips = [
  'Spread your investments across different asset classes like stocks, bonds, and real estate to minimize risk. By not putting all your money in one type of investment, you can protect yourself against market volatility and increase your chances of achieving stable, long-term financial growth.',
  "Save at least 3-6 months’ worth of living expenses in an easily accessible account. This fund provides a financial safety net for unexpected expenses like medical emergencies or job loss, ensuring you can cover your basic needs without resorting to debt.",
  "Prioritize saving before spending. Set up automatic transfers to savings or retirement accounts. This strategy ensures that you consistently save a portion of your income, helping you build wealth over time and avoid the temptation to spend money before saving.",
  "Pay off credit cards and high-interest loans promptly to save on interest charges. This helps you reduce the overall cost of borrowing and prevents debt from accumulating, freeing up more of your income for savings and investments.",
  "Avoid trying to time the market; instead, focus on long-term growth. This strategy helps you ride out market volatility and benefit from compounding returns over time, which can lead to significant wealth accumulation.",
  "Understand the tax implications of your investments and take advantage of tax-efficient strategies. This knowledge can help you minimize tax liability, maximize returns, and ensure compliance with tax laws, ultimately enhancing your overall financial health and investment outcomes.",
  "Living below your means involves budgeting wisely, prioritizing needs over wants, and saving or investing the surplus income. It fosters financial stability, reduces debt, and allows for future financial goals like investments or emergencies without relying on credit. This practice cultivates sustainable wealth-building habits and financial security.",
  "Regularly reviewing your finances is essential for maintaining financial health. It involves checking your budget to ensure it's realistic and adjusting it as needed. You should monitor your investments' performance, reassess your financial goals, and make strategic adjustments to optimize your savings and investment strategies over time.",
  "Health insurance ensures you're financially covered for medical expenses, offering peace of mind during emergencies. Estate planning involves creating legal documents like wills and trusts to protect and distribute your assets according to your wishes, minimizing disputes and ensuring your legacy is managed as you intend.",
  "Educating yourself in finance through books, blogs, and seminars enhances your understanding of money management, investing strategies, and economic trends. This knowledge empowers better financial decision-making, improving your ability to grow wealth and achieve long-term financial stability.",
];

String getTip(BuildContext context){
  Random random = Random();
  int randomIndex = random.nextInt(tips.length);
  String randomTip = tips[randomIndex];

  return randomTip;
}