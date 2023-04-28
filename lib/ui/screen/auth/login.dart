import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login").tr(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 42,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color!, width: 2)),
              child: const Icon(
                FontAwesomeIcons.rightFromBracket,
                size: 70,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: (Theme.of(context)
                      .inputDecorationTheme
                      .enabledBorder as OutlineInputBorder)
                  .borderRadius,
              border: Border.all(
                  color: Theme.of(context)
                      .inputDecorationTheme
                      .enabledBorder!
                      .borderSide
                      .color),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone),
                InkWell(
                  onTap: () => showDialog(
                      context: context, builder: (_) => CountryDialog()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '+60',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number".tr(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password".tr(),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Login").tr())
        ],
      ),
    );
  }
}
