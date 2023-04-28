import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/ui/constant.dart';
import 'package:sun_point/utils/ui/file_path.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DrawerPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SideBarHeader(),
            const SizedBox(
              height: 30,
            ),
            Padding(
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
                        itemBuilder: (context, index, realIndex) => SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/home/w${index + 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        options: CarouselOptions(
                            autoPlay: true,
                            height: 120,
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).iconTheme.color!),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomBar: BottomBar(),
    );
  }

  Widget _contentServices(BuildContext context) {
    List<ModelServices> listServices = [];

    listServices.add(ModelServices(title: "QR", img: 'qr'));
    listServices.add(ModelServices(title: "Transfer", img: 'transfer'));
    listServices.add(ModelServices(title: "Top Up", img: 'topup'));
    listServices.add(ModelServices(title: "Exchange", img: 'exchange'));
    listServices.add(ModelServices(title: "Network", img: 'network'));
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
                // print('${value.title}');
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
  String title, img;
  ModelServices({required this.title, required this.img});
}
