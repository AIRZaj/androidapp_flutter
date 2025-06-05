import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uam_contacts/main.dart';

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // There should be at least one Scaffold (the main one)
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    // There should be a BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Bottom navigation should have 4 items', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check for the labels of the navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Aktualności'), findsOneWidget);
    expect(find.text('Authors'), findsOneWidget);

    // Optionally, check that there are 4 items in the BottomNavigationBar
    final bottomNavBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNavBar.items.length, 4);
  });
} 