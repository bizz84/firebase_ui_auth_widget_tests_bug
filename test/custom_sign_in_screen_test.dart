import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth_widget_tests_bug/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() async {
  testWidgets('custom sign in screen ...', (tester) async {
    final mockAuth = MockFirebaseAuth();
    final mockFirebaseApp = MockFirebaseApp();
    when(() => mockAuth.app).thenReturn(mockFirebaseApp);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: CustomSignInScreen(),
        ),
      ),
    );
  });
}
