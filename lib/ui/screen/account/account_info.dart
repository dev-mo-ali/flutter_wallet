import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sun_point/logic/controllers/account/account_info.dart';
import 'package:sun_point/logic/models/account/account_info.dart';
import 'package:sun_point/server/server.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/ui/file_path.dart';
import 'package:sun_point/utils/validators.dart';

class AccountInfoPage extends StatelessWidget {
  AccountInfoPage({super.key});
  final TextEditingController name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountInfoCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccountInfoCubit, AccountInfoState>(
            listenWhen: (previous, current) =>
                previous.user != current.user && previous.user == null,
            listener: (context, state) {
              name.text = state.user!.name ?? '';
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
          body: BlocSelector<AccountInfoCubit, AccountInfoState, User?>(
            selector: (state) => state.user,
            builder: (context, state) {
              if (state == null) {
                return const Center(
                  child: CircularProgressIndicator(),
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
                        dimension: 160,
                        child: BlocBuilder<AccountInfoCubit, AccountInfoState>(
                          buildWhen: (previous, current) =>
                              previous.avatarLoading != current.avatarLoading,
                          builder: (context, state) => state.avatarLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: state.user!.avatar == null
                                      ? SvgPicture.asset(avatorOne)
                                      : Image.network(
                                          Server.getAbsluteUrl(
                                              state.user!.avatar!),
                                          headers: const {
                                            'Connection': 'Keep-Alive'
                                          },
                                          fit: BoxFit.contain,
                                        ),
                                ),
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
                    state.username,
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
                        TextFormField(
                          validator: isNotEmpty,
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'Name'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 64,
                    child:
                        BlocSelector<AccountInfoCubit, AccountInfoState, bool>(
                      selector: (state) => state.loading,
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
                          context.read<AccountInfoCubit>().submit(name.text);
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
