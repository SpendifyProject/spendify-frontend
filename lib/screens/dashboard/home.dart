import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/profile/preferences.dart';
import 'package:spendify/screens/transactions/budget.dart';
import 'package:spendify/screens/transactions/record.dart';
import 'package:spendify/screens/transactions/schedule.dart';
import 'package:spendify/screens/transactions/send_money.dart';
import 'package:spendify/screens/transactions/transaction_history.dart';
import 'package:spendify/widgets/double_header.dart';

import '../../const/routes.dart';
import '../../widgets/credit_card_widget.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/transaction_widget.dart';
import '../payment_methods/add_credit_card.dart';
import '../payment_methods/add_momo_account.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.email});
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;
  bool isLoading = true;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: FutureBuilder(
        future: userProvider.getUserData(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading = true;
            return const SizedBox();
          } else if (snapshot.hasError) {
            showErrorDialog(context, 'Error: ${snapshot.error}');
          } else {
            final User user = userProvider.user;
            isLoading = false;

            List info = [
              {
                'title':
                    'Add your credit card to ensure a seamless payment experience',
                'route': AddCard(uid: user.uid),
                'asset': 'assets/images/cards.jpeg',
              },
              {
                'title':
                    'Add your mobile money account to ensure a seamless payment experience',
                'route': AddMomo(uid: user.uid),
                'asset': 'assets/images/momo.jpeg',
              },
              {
                'title': 'Edit your payment preferences',
                'route': const PaymentPreferences(),
                'asset': 'assets/images/prefs.jpeg',
              },
            ];

            final pages = List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return info[index]['route'];
                        },
                      ),
                    );
                  },
                  child: Container(
                      width: double.infinity,
                      height: 300.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: color.onSurface,
                          border: Border.all(color: color.onPrimary)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              info[index]['asset'],
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 200.h,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            info[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: color.onPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              child: ListView(
                children: [
                  Skeletonizer(
                    enabled: isLoading,
                    child: ListTile(
                      isThreeLine: true,
                      contentPadding: EdgeInsets.zero,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, profileRoute);
                        },
                        child: ClipOval(
                          child: Image.network(
                            user.imagePath,
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                      ),
                      title: Text(
                        'Welcome,',
                        style: TextStyle(
                          color: color.secondary,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        user.fullName,
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      padEnds: false,
                      controller: controller,
                      itemCount: pages.length,
                      itemBuilder: (_, index) {
                        return pages[index % pages.length];
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        dotColor: color.onSurface,
                        activeDotColor: color.primary,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 90.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TransactionButton(
                            iconData: Icons.arrow_upward,
                            label: 'Send',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SendMoney(user: user);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TransactionButton(
                            iconData: Icons.schedule_outlined,
                            label: 'Schedule',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ScheduleTransaction(
                                      user: user,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TransactionButton(
                            iconData: Icons.savings_outlined,
                            label: 'Budget',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Budget();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TransactionButton(
                            iconData: Icons.add,
                            label: 'Record',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return RecordTransaction(
                                      user: user,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  DoubleHeader(
                    leading: 'Transactions',
                    trailing: 'See All',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Transactions(user: user);
                          },
                        ),
                      );
                    },
                  ),
                  const TransactionWidget(
                    name: 'Spotify',
                    category: 'Entertainment',
                    icon: 'entertainment',
                    isDebit: true,
                    amount: 8.50,
                  ),
                  const TransactionWidget(
                    name: 'Apple TV',
                    category: 'Entertainment',
                    icon: 'entertainment',
                    isDebit: true,
                    amount: 12.99,
                  ),
                  const TransactionWidget(
                    name: 'Groceries',
                    category: 'Food and Dining',
                    icon: 'food',
                    isDebit: true,
                    amount: 30,
                  ),
                  const TransactionWidget(
                    name: 'Cash In',
                    category: 'Money Transfer',
                    icon: 'transfer',
                    isDebit: false,
                    amount: 300,
                  ),
                  const TransactionWidget(
                    name: 'Gym Membership',
                    category: 'Health and Fitness',
                    icon: 'health',
                    isDebit: true,
                    amount: 250,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class TransactionButton extends StatelessWidget {
  const TransactionButton(
      {super.key, required this.iconData, required this.label, this.onTap});

  final IconData iconData;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color.onSurface,
            radius: 27.w,
            child: Icon(
              iconData,
              color: color.onPrimary,
              size: 30,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 13,
          ),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
