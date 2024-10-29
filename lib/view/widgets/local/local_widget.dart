import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/local.dart';
import '../../../utilities/screen.dart';
import 'select_local.dart';

class LocalWidget extends StatelessWidget {
  const LocalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                width: widthScreen(context),
                child: const SelectLocal(),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: mainWhiteColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Image.asset(
              getLocale(context.locale.toString())[1],
              width: 30,
            ),
            const SizedBox(width: 8),
            Text(
              getLocale(context.locale.toString())[0],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
