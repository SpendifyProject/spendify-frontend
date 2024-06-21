import 'package:flutter/material.dart';

List<String> categories = [
  'Entertainment',
  'Food and Dining',
  'Rent and Housing',
  'Health and Fitness',
  'Shopping',
  'Transport',
  'Utilities and Repairs',
  'Other'
];

IconData pickCategoryIcon(String category) {
  if (category == 'Entertainment') {
    return Icons.movie_filter_outlined;
  } else if (category == 'Food and Dining') {
    return Icons.fastfood_outlined;
  } else if (category == 'Rent and Housing') {
    return Icons.house_outlined;
  } else if (category == 'Health and Fitness') {
    return Icons.health_and_safety_outlined;
  } else if (category == 'Shopping') {
    return Icons.shopping_bag_outlined;
  } else if (category == 'Transport') {
    return Icons.directions_bus_filled_outlined;
  } else if (category == 'Utilities and Repairs') {
    return Icons.electrical_services_sharp;
  } else {
    return Icons.more_horiz;
  }
}
