import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';

class ShowQRPage extends StatefulWidget {
  const ShowQRPage({super.key});

  @override
  State<ShowQRPage> createState() => _ShowQRPageState();
}

class _ShowQRPageState extends State<ShowQRPage> {
  @override
  void initState() {
    Future.delayed(const Duration(minutes: 1)).then(
        (value) => Navigator.of(context).pushReplacementNamed(Routes.enterPIN));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SizedBox(
              height: 400,
              child: Card(
                elevation: 6,
                child: FutureBuilder(
                    future: User.getUser(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: snapshot.data!.avatar == null
                                        ? const Icon(
                                            Icons.person_outlined,
                                            size: 45,
                                          )
                                        : Image.network(
                                            snapshot.data!.avatar!,
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
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data!.name!,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(snapshot.data!.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Expanded(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 350),
                                  child: QrImage(
                                    data: snapshot.data!.qr!,
                                    // TODO: add logo
                                    // embeddedImage: const AssetImage(
                                    //   logo,
                                    // ),
                                    embeddedImageStyle: QrEmbeddedImageStyle(
                                        size: const Size.square(44)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )),
        ),
      ),
    );
  }
}
