import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/home.dart';
import 'package:sun_point/logic/models/home.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/screen/wallet/user_balance.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/contact_us.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/ui/constant.dart';
import 'package:sun_point/utils/ui/file_path.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: DrawerPage(
        current: Routes.home,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SideBarHeader(),
              const SizedBox(
                height: 30,
              ),
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) =>
                    previous.loading != current.loading,
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!state.loading && !state.loaded) {
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
                                  .read<HomeCubit>()
                                  .load()
                                  .then((value) => null),
                              child: const Text('Retry').tr())
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accent)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CarouselSlider.builder(
                              itemCount: 3,
                              itemBuilder: (context, index, realIndex) =>
                                  SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/home/w${index + 1}.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval:
                                      const Duration(milliseconds: 6500),
                                  height: 120,
                                  reverse: true,
                                  viewportFraction: 1,
                                  padEnds: false),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Services',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SvgPicture.asset(
                              filter,
                              color: Theme.of(context).iconTheme.color,
                              width: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _contentServices(context),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context).iconTheme.color!),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/home/2.png',
                                          width: 40,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Image.asset(
                                          'assets/home/3.png',
                                          width: 48,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Image.asset(
                                          'assets/home/4.png',
                                          width: 50,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Discover More",
                                              style: TextStyle(fontSize: 14),
                                            ).tr()),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        )
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.promotions!.isNotEmpty,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: AppColors.accent)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CarouselSlider.builder(
                                    itemCount: state.promotions!.length,
                                    itemBuilder: (context, index, realIndex) =>
                                        GestureDetector(
                                      onTap: () {
                                        Uri uri = Uri.parse(
                                            state.promotions![index]['url']);
                                        launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                      child: SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Image.network(
                                          state.promotions![index]['img'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        height: 220,
                                        reverse: true,
                                        viewportFraction: 1,
                                        padEnds: false),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
        bottomBar: const BottomBar(
          currentIndex: 0,
        ),
      ),
    );
  }

  Widget _contentServices(BuildContext context) {
    List<ModelServices> listServices = [];

    listServices
        .add(ModelServices(title: "QR", img: 'qr', route: Routes.enterPIN));
    listServices.add(ModelServices(
        title: "Transfer", img: 'transfer', route: Routes.transfer));
    listServices
        .add(ModelServices(title: "Top Up", img: 'topup', route: Routes.topUp));
    listServices.add(ModelServices(
        title: "Withdraw", img: 'withdraw', route: Routes.withdraw));
    listServices.add(ModelServices(
        title: "Exchange",
        img: 'exchange',
        onClick: () => showDialog(
            context: context, builder: (_) => const ContactUsDialog())));
    listServices.add(ModelServices(title: "Network", img: 'network'));
    listServices.add(ModelServices(
      title: "My Balance",
      img: 'balance',
      onClick: () => showDialog(
          context: context, builder: (_) => const UserBalanceDialog()),
    ));
    listServices.add(ModelServices(title: "More Options", img: 'menu'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: .95,
          children: listServices.map((value) {
            return GestureDetector(
              onTap: () {
                if (value.route != null) {
                  Navigator.of(context).pushNamed(value.route!);
                } else if (value.onClick != null) {
                  value.onClick!();
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/${value.img}.svg',
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    value.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ).tr(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ModelServices {
  final String title, img;
  final String? route;
  final void Function()? onClick;
  ModelServices(
      {required this.title, required this.img, this.route, this.onClick});
}
