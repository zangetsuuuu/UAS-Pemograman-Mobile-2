import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/utils/app_colors.dart';

class CustomerDrawer extends StatelessWidget {
  CustomerDrawer({super.key});

  /// Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  final List<String> texts = [
    'Beranda',
    'Profil',
    'Pengaturan',
    'Tentang',
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/115514467?v=4',
            ),
          ),
          8.h,
          Text('Rafif Athallah', style: textTheme.displayMedium),
          1.h,
          Text('@cenktzy', style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    debugPrint('Tapped at index $index');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(
                        icons[index],
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        texts[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
