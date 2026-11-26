import 'package:flutter/material.dart';

import 'data/repositories/menu_repository.dart';
import 'ui/core/window_size.dart';
import 'ui/menu/menu_screen.dart';
import 'ui/menu/menu_view_model.dart';
import 'ui/pesanan/pesanan_screen.dart';

void main() => runApp(const NusaKantinApp());

class NusaKantinApp extends StatelessWidget {
  const NusaKantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKantin',
      debugShowCheckedModeBanner: false,
      theme: _buatTema(),
      home: const HomeShell(),
    );
  }
}

/// Tema flat: warna solid, tanpa gradasi, tanpa bayangan.
ThemeData _buatTema() {
  const latar = Color(0xFFF6F8F7);
  const garis = Color(0xFFE2E8E5);
  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E));

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: latar,
    appBarTheme: AppBarTheme(
      backgroundColor: latar,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: garis),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: scheme.primaryContainer,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorColor: scheme.primaryContainer,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: scheme.primaryContainer,
      side: const BorderSide(color: garis),
      shape: const StadiumBorder(),
    ),
    dividerTheme: const DividerThemeData(color: garis, space: 1, thickness: 1),
  );
}

/// Kerangka aplikasi: NavigationBar (HP) atau NavigationRail (tablet).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final MenuViewModel _viewModel = MenuViewModel(const MenuRepository());
  int _index = 0;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _pilihTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final jumlah = _viewModel.totalJumlah;

        final halaman = IndexedStack(
          index: _index,
          children: [
            MenuScreen(viewModel: _viewModel),
            PesananScreen(viewModel: _viewModel),
          ],
        );

        Widget ikonPesanan(IconData icon) => Badge(
              isLabelVisible: jumlah > 0,
              label: Text('$jumlah'),
              child: Icon(icon),
            );

        final appBar = AppBar(title: const Text('NusaKantin'));

        if (size.isCompact) {
          return Scaffold(
            appBar: appBar,
            body: SafeArea(bottom: false, child: halaman),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _pilihTab,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  selectedIcon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                NavigationDestination(
                  icon: ikonPesanan(Icons.receipt_long_outlined),
                  selectedIcon: ikonPesanan(Icons.receipt_long),
                  label: 'Pesanan',
                ),
              ],
            ),
          );
        }

        final extended = size.isExpanded;
        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: Row(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          selectedIndex: _index,
                          onDestinationSelected: _pilihTab,
                          extended: extended,
                          labelType: extended
                              ? NavigationRailLabelType.none
                              : NavigationRailLabelType.all,
                          destinations: [
                            const NavigationRailDestination(
                              icon: Icon(Icons.restaurant_menu_outlined),
                              selectedIcon: Icon(Icons.restaurant_menu),
                              label: Text('Menu'),
                            ),
                            NavigationRailDestination(
                              icon: ikonPesanan(Icons.receipt_long_outlined),
                              selectedIcon: ikonPesanan(Icons.receipt_long),
                              label: const Text('Pesanan'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(),
                Expanded(child: halaman),
              ],
            ),
          ),
        );
      },
    );
  }
}
