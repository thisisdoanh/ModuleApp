import 'package:flutter/material.dart';

import 'app.dart';
import 'di/injection.dart';
import 'flavors.dart';

const String appFlavor = String.fromEnvironment(
  'FLAVOR',
  defaultValue: 'dev',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup flavor
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
    orElse: () => Flavor.dev,
  );

  // Initialize dependency injection
  await configureDependencies();

  runApp(App());
}
