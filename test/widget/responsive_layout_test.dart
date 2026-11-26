import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kantin/main.dart';

Widget _app({double textScale = 1.0}) {
  return Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: const NusaKantinApp(),
    ),
  );
}

void _ukuran(WidgetTester tester, double lebar, double tinggi) {
  tester.view.physicalSize = Size(lebar, tinggi);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _tambahMenuPertama(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Nasi Goreng Spesial'));
  await tester.tap(find.text('Nasi Goreng Spesial'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Tambah ke pesanan'));
  await tester.tap(find.text('Tambah ke pesanan'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('compact (HP portrait): NavigationBar + ListView', (tester) async {
    _ukuran(tester, 400, 800);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(SliverGrid), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded (tablet): NavigationRail + grid + detail samping',
      (tester) async {
    _ukuran(tester, 1000, 800);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.text('Tambah ke pesanan'), findsNothing);

    await tester.tap(find.text('Nasi Goreng Spesial'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah ke pesanan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tanpa overflow: teks 200% di HP portrait', (tester) async {
    _ukuran(tester, 360, 640);
    await tester.pumpWidget(_app(textScale: 2.0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tambahMenuPertama(tester);

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('tanpa overflow: teks 200% di HP landscape', (tester) async {
    _ukuran(tester, 800, 360);
    await tester.pumpWidget(_app(textScale: 2.0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tambahMenuPertama(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
