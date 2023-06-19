import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/account/scan_qr.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sun_point/logic/models/account/scan_qr.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';

class ScanQrPage extends StatelessWidget {
  ScanQrPage({super.key});
  final MobileScannerController controller = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanQrCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ScanQrCubit, ScanQrState>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<ScanQrCubit, ScanQrState>(
              listenWhen: (previous, current) => current.data != null,
              listener: (context, state) {
                Navigator.of(context).pop(state.data);
              },
            ),
          ],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  height: 400,
                  child: Builder(builder: (context) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MobileScanner(
                            controller: controller,
                            onDetect: (capture) {
                              if (capture.barcodes.isNotEmpty) {
                                String qr = capture.barcodes.first.rawValue!;
                                context.read<ScanQrCubit>().getUser(qr);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox.square(
                  dimension: 32,
                  child: BlocSelector<ScanQrCubit, ScanQrState, bool>(
                    selector: (state) {
                      return state.loading;
                    },
                    builder: (context, state) {
                      return Visibility(
                          visible: state,
                          child: const CircularProgressIndicator());
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
