# firebase_ui_auth_widget_tests_bug

A simple demo app showing a bug that causes widget tests to fail with the Firebase UI Auth package.


### Main File

```dart
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_auth_widget_tests_bug/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomSignInScreen(),
    );
  }
}

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SignInScreen(
        auth: ref.watch(firebaseAuthProvider),
        providers: [EmailAuthProvider()],
      ),
    );
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
```

### Widget test file

```dart
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
```

### Test failure

Running the test above causes the following error:


```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following _Exception was thrown building KeyedSubtree-[GlobalKey#cb6c1]:
Exception: You must call Firebase.initializeApp() before calling configureProviders()

The relevant error-causing widget was:
  Scaffold
  Scaffold:file:///Users/andrea/work/codewithandrea/github/flutter/firebase_ui_auth_widget_tests_bug/lib/main.dart:36:12

When the exception was thrown, this was the stack:
#0      FirebaseUIAuth.configureProviders (package:firebase_ui_auth/firebase_ui_auth.dart:115:7)
#1      ScreenElement.mount (package:firebase_ui_auth/src/screens/internal/multi_provider_screen.dart:50:24)
...     Normal element mounting (25 frames)
#26     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3953:16)
#27     MultiChildRenderObjectElement.inflateWidget (package:flutter/src/widgets/framework.dart:6512:36)
#28     MultiChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6524:32)
...     Normal element mounting (326 frames)
#354    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3953:16)
#355    MultiChildRenderObjectElement.inflateWidget (package:flutter/src/widgets/framework.dart:6512:36)
#356    MultiChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6524:32)
...     Normal element mounting (467 frames)
#823    _UncontrolledProviderScopeElement.mount (package:flutter_riverpod/src/framework.dart:309:11)
...     Normal element mounting (9 frames)
#832    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3953:16)
#833    Element.updateChild (package:flutter/src/widgets/framework.dart:3676:20)
#834    RenderObjectToWidgetElement._rebuild (package:flutter/src/widgets/binding.dart:1176:16)
#835    RenderObjectToWidgetElement.update (package:flutter/src/widgets/binding.dart:1153:5)
#836    RenderObjectToWidgetElement.performRebuild (package:flutter/src/widgets/binding.dart:1167:7)
#837    Element.rebuild (package:flutter/src/widgets/framework.dart:4690:5)
#838    BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2743:19)
#839    AutomatedTestWidgetsFlutterBinding.drawFrame (package:flutter_test/src/binding.dart:1336:19)
#840    RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:381:5)
#841    SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1289:15)
#842    SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1218:9)
#843    AutomatedTestWidgetsFlutterBinding.pump.<anonymous closure> (package:flutter_test/src/binding.dart:1185:9)
#846    TestAsyncUtils.guard (package:flutter_test/src/test_async_utils.dart:71:41)
#847    AutomatedTestWidgetsFlutterBinding.pump (package:flutter_test/src/binding.dart:1171:27)
#848    WidgetTester.pumpWidget.<anonymous closure> (package:flutter_test/src/widget_tester.dart:558:22)
#851    TestAsyncUtils.guard (package:flutter_test/src/test_async_utils.dart:71:41)
#852    WidgetTester.pumpWidget (package:flutter_test/src/widget_tester.dart:555:27)
#853    main.<anonymous closure> (file:///Users/andrea/work/codewithandrea/github/flutter/firebase_ui_auth_widget_tests_bug/test/custom_sign_in_screen_test.dart:18:18)
#854    testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:171:29)
<asynchronous suspension>
<asynchronous suspension>
(elided 5 frames from dart:async and package:stack_trace)

════════════════════════════════════════════════════════════════════════════════════════════════════
```


## Running the app

Before running the app, make sure to add a Firebase project using the flutterfire CLI.

```
flutterfire configure
```

