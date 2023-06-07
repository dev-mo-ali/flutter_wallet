import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/logic/controllers/profile/account_info.dart';
import 'package:sun_point/logic/models/account/account_info.dart';

import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/validators.dart';

class AccountInfoPage extends StatelessWidget {
  AccountInfoPage({super.key});
  final TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      emergencyName = TextEditingController(),
      emergencyPhone = TextEditingController(),
      emergencyRelationship = TextEditingController(),
      idNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final DateFormat format = DateFormat('yyyy-MM-dd', 'en');
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountInfoCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccountInfoCubit, AccountInfoState>(
            listenWhen: (previous, current) =>
                current.data != previous.data && current.data != null,
            listener: (context, state) {
              name.text = state.data!['user']['name'];
              email.text = state.data!['user']['email'];
              idNumber.text = state.data!['user']['identification_number'];
              emergencyName.text =
                  state.data!['emergency_contacts']['full_name'];
              emergencyPhone.text =
                  state.data!['emergency_contacts']['phone_number'];
              emergencyRelationship.text =
                  state.data!['emergency_contacts']['relationship'];
            },
          ),
          BlocListener<AccountInfoCubit, AccountInfoState>(
            listenWhen: (previous, current) => current.error.isNotEmpty,
            listener: (context, state) {
              showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(
                        error: state.error,
                      ));
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Profile').tr(),
          ),
          body: BlocBuilder<AccountInfoCubit, AccountInfoState>(
            buildWhen: (previous, current) =>
                previous.loading != current.loading || current.done,
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!state.loading && state.data == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Error occurred.",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          onPressed: () => context
                              .read<AccountInfoCubit>()
                              .load()
                              .then((value) => null),
                          child: const Text('Retry').tr())
                    ],
                  ),
                );
              }

              if (state.done) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 42,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(
                                  color: Theme.of(context).iconTheme.color!,
                                  width: 2)),
                          child: const Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 70,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Center(
                        child: Text('SUCCESS!',
                                style:
                                    Theme.of(context).textTheme.displayMedium)
                            .tr(),
                      ),
                      Center(
                        child: Text(
                          'profileUpdateSucc',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ).tr(),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok').tr())
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.read<AccountInfoCubit>().pickImage(),
                      child: SizedBox.square(
                        dimension: 130,
                        child: BlocBuilder<AccountInfoCubit, AccountInfoState>(
                          buildWhen: (previous, current) =>
                              previous.avatarLoading != current.avatarLoading,
                          builder: (context, state) => state.avatarLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: state.data!['user']['avatar'] == null
                                        ? const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 100,
                                          )
                                        : Image.network(
                                            state.data!['user']['avatar'],
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }

                                              if (loadingProgress
                                                      .cumulativeBytesLoaded >=
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      0)) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              return child;
                                            },
                                          ),
                                  )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    state.data!['user']['username'],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Personal Info',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                          ),
                        ),
                        TextFormField(
                          validator: isNotEmpty,
                          controller: name,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            hintText: 'Name'.tr(),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
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
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: BlocSelector<AccountInfoCubit,
                                    AccountInfoState, DateTime?>(
                                  selector: (state) {
                                    return state.birth;
                                  },
                                  builder: (context, state) {
                                    return InkWell(
                                      onTap: () async {
                                        DateTime? birth = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime.now(),
                                          builder: (context, child) => Theme(
                                              data: ThemeData(
                                                  colorScheme: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? ColorScheme.dark(
                                                          primary:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          surface:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.white54,
                                                        )
                                                      : ColorScheme.light(
                                                          primary:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          surface:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.black54,
                                                        )),
                                              child: child!),
                                        );
                                        if (birth != null) {
                                          context
                                              .read<AccountInfoCubit>()
                                              .setBirth(birth);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          state != null
                                              ? format.format(state)
                                              : 'Birthday'.tr(),
                                          style: Theme.of(context)
                                              .inputDecorationTheme
                                              .labelStyle,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Identification',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                          ).tr(),
                        ),
                        TextFormField(
                          validator: isNotEmpty,
                          controller: idNumber,
                          decoration: InputDecoration(
                            labelText: "Identification Number".tr(),
                            prefixIcon: const Icon(Icons.numbers),
                          ),
                        ),
                        BlocSelector<AccountInfoCubit, AccountInfoState,
                            String?>(
                          selector: (state) {
                            return state.idType?.toLowerCase() ?? '';
                          },
                          builder: (context, state) {
                            return Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: 'ic',
                                    groupValue: state,
                                    onChanged: (value) => context
                                        .read<AccountInfoCubit>()
                                        .setIdType(value!),
                                    title: const Text('IC').tr(),
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: 'passport',
                                    groupValue: state,
                                    onChanged: (value) => context
                                        .read<AccountInfoCubit>()
                                        .setIdType(value!),
                                    title: const Text('Passport').tr(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Emergency Contact',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                          ),
                        ),
                        TextFormField(
                          validator: isNotEmpty,
                          controller: emergencyName,
                          decoration: InputDecoration(
                            labelText: "Full Name".tr(),
                            prefixIcon: const Icon(Icons.person_2_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: isNotEmpty,
                          controller: emergencyRelationship,
                          decoration: InputDecoration(
                            labelText: "Relationship".tr(),
                            prefixIcon:
                                const Icon(FontAwesomeIcons.peopleArrows),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: phoneNumberValidator,
                          controller: emergencyPhone,
                          decoration: InputDecoration(
                            labelText: "Phone Number".tr(),
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 64,
                    child:
                        BlocSelector<AccountInfoCubit, AccountInfoState, bool>(
                      selector: (state) => state.submitting,
                      builder: (context, state) {
                        return state
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AccountInfoCubit>().submit(
                              name.text,
                              idNumber.text,
                              emergencyName.text,
                              emergencyPhone.text,
                              emergencyRelationship.text);
                        }
                      },
                      child: const Text('Update').tr())
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
