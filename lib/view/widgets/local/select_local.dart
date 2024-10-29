import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import 'all_local.dart';

class SelectLocal extends StatefulWidget {
  const SelectLocal({super.key});

  @override
  State<SelectLocal> createState() => _SelectLocalState();
}

class _SelectLocalState extends State<SelectLocal> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              context.tr("selectLocal"),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              itemCount: localItems.length,
              itemBuilder: (context, index) {
                final item = localItems[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
                  child: GestureDetector(
                    onTap: () {
                      context.setLocale(Locale(item.local, item.code));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100)),
                      child: ListTile(
                        leading:
                            Image.asset(item.imagePath, width: 50, height: 50),
                        title: Text(item.name),
                        subtitle: Text(item.code),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
