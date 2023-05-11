import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SetLangDialog extends StatelessWidget {
  const SetLangDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                'Change Language',
                style: Theme.of(context).textTheme.displayMedium,
              ).tr(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        context.setLocale(const Locale('zh'));
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/zh.png'),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Chinese',
                            style: TextStyle(fontSize: 18),
                          ).tr()
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.setLocale(const Locale('en'));
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/en.png'),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'English',
                            style: TextStyle(fontSize: 18),
                          ).tr()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
