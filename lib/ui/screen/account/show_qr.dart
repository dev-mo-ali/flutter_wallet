import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sun_point/utils/auth.dart';

class ShowQRPage extends StatelessWidget {
  const ShowQRPage({super.key});

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
                                    decoration: const BoxDecoration(),
                                    child: snapshot.data!.avatar == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color!),
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                            ),
                                            child: const Icon(
                                              Icons.person_outlined,
                                              size: 45,
                                            ),
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
                                    const Text(
                                      'hiUser',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ).tr(args: [snapshot.data!.name!]),
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
