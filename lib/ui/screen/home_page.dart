import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
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
                  Text(
                    'Account Overview',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.accent)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CarouselSlider.builder(
                          itemCount: 4,
                          itemBuilder: (context, index, realIndex) =>
                              SvgPicture.asset(
                                logo,
                                height: 100,
                              ),
                          options: CarouselOptions(
                              autoPlay: true,
                              height: 260,
                              viewportFraction: 1,
                              padEnds: false)),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _contentOverView() {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
        // color: const Color(0xffF1F3F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '20,600',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Current Balance',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
              )
            ],
          ),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: const Color(0xffFFAC30),
              borderRadius: BorderRadius.circular(80),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentSendMoney() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 80,
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              top: 28,
              bottom: 28,
            ),
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Color(0xffFFAC30),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(16),
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffD8D9E4))),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: ClipRRect(
                      child: SvgPicture.asset(avatorOne),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                Text(
                  'Mike',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(16),
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffD8D9E4))),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: ClipRRect(
                      child: SvgPicture.asset(avatorTwo),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                Text(
                  'Joseph',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(16),
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffD8D9E4))),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: ClipRRect(
                      child: SvgPicture.asset(avatorThree),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                Text(
                  'Ashley',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _contentServices(BuildContext context) {
    List<ModelServices> listServices = [];

    listServices.add(ModelServices(title: "Send\nMoney", img: send));
    listServices.add(ModelServices(title: "Receive\nMoney", img: recive));
    listServices.add(ModelServices(title: "Mobile\nPrepaid", img: mobile));
    listServices
        .add(ModelServices(title: "Electricity\nBill", img: electricity));
    listServices.add(ModelServices(title: "Cashback\nOffer", img: cashback));
    listServices.add(ModelServices(title: "Movie\nTickets", img: movie));
    listServices.add(ModelServices(title: "Flight\nTickets", img: flight));
    listServices.add(ModelServices(title: "More\nOptions", img: menu));

    return SizedBox(
      width: double.infinity,
      height: 400,
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.1),
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
                    value.img,
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
                ),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ModelServices {
  String title, img;
  ModelServices({required this.title, required this.img});
}
