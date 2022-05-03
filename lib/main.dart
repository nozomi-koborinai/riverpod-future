import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/data/postal_code.dart';
import 'package:riverpod_future/provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: ((value) => onPostalCodeChanged(ref, value)),
            ),
            Text(postalCode?.data[0].en.address1 ?? 'No postal Code'),
          ],
        ),
      ),
    );
  }

  void onPostalCodeChanged(WidgetRef ref, String value) {
    print(value);
    if (value.length != 7) {
      return;
    }
    try {
      int.parse(value);
      ref.watch(postalCodeProvider.state).state = value;
    } catch (ex) {}
  }
}
