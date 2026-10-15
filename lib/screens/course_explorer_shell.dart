// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 14: Course Explorer v2 - shell responsif
//   Lebar (>=840): NavigationRail. Sempit: NavigationBar.
//   Isi tiap tab berasal dari CourseProvider (arsitektur baru).
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_bar.dart';
import 'course_list_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class CourseExplorerShell extends StatefulWidget {
  const CourseExplorerShell({super.key});

  @override
  State<CourseExplorerShell> createState() => _CourseExplorerShellState();
}

class _CourseExplorerShellState extends State<CourseExplorerShell> {
  int _index = 0;

  // Isi tiap "tab". Dibungkus IndexedStack supaya state tiap tab terjaga.
  Widget _buildBody() {
    return IndexedStack(
      index: _index,
      children: const [
        CourseListScreen(),
        FavoritesScreen(),
        ProfileScreen(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // watch -> indikator jumlah favorite ikut berubah dari screen mana pun.
    final int favCount = context.watch<CourseProvider>().jumlahFavorite;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint mengikuti pertemuan sebelumnya (Expanded >= 840).
        final bool wide = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer v2'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(child: Text('★ $favCount')),
              ),
              IconButton(
                tooltip: 'Muat ulang',
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<CourseProvider>().loadCourses(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Nama + NIM selalu terlihat di semua tab.
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: IdentityBar(name: studentName, nim: studentId),
              ),
              Expanded(
                child: wide
                    ? Row(
                        children: [
                          NavigationRail(
                            selectedIndex: _index,
                            onDestinationSelected: (i) =>
                                setState(() => _index = i),
                            labelType: NavigationRailLabelType.all,
                            destinations: const [
                              NavigationRailDestination(
                                icon: Icon(Icons.school_outlined),
                                selectedIcon: Icon(Icons.school),
                                label: Text('Courses'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.star_border),
                                selectedIcon: Icon(Icons.star),
                                label: Text('Favorites'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.person_outline),
                                selectedIcon: Icon(Icons.person),
                                label: Text('Profile'),
                              ),
                            ],
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(child: _buildBody()),
                        ],
                      )
                    : _buildBody(),
              ),
            ],
          ),
          // Navigasi bawah hanya untuk layar sempit.
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: 'Courses',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.star_border),
                      selectedIcon: Icon(Icons.star),
                      label: 'Favorites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
