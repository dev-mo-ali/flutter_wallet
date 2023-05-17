import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/drawer.dart';

import 'package:sun_point/ui/screen/home.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/ui/file_path.dart';

class DrawerPage extends StatefulWidget {
  Widget child;
  Widget? bottomBar;
  DrawerPage({
    Key? key,
    required this.child,
    this.bottomBar,
  }) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  bool sideBarActive = false;
  late AnimationController rotationController;
  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocListener<DrawerCubit, bool>(
          listener: (context, state) {
            if (state) {
              openSideBar();
            } else {
              closeSideBar();
            }
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: User.getUser(),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return const SizedBox();
                            }
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(60)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xffD8D9E4))),
                                      child: CircleAvatar(
                                        radius: 22.0,
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        child: ClipRRect(
                                          child: SvgPicture.asset(avatorOne),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snap.data!.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Text(
                                          snap.data!.username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        navigatorTitle("Home", true),
                        navigatorTitle("Profile", false),
                        navigatorTitle("Accounts", false),
                        navigatorTitle("Transactions", false),
                        navigatorTitle("Stats", false),
                        navigatorTitle("Settings", false),
                        navigatorTitle("Help", false),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () async {
                        await User.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.mainAuth, (route) => false);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            size: 24,
                            color: Theme.of(context).iconTheme.color,
                            // color: sideBarActive ? Colors.black : Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Logout",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Ver 2.0.1",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: (sideBarActive)
                    ? MediaQuery.of(context).size.width * 0.6
                    : 0,
                top: (sideBarActive)
                    ? MediaQuery.of(context).size.height * 0.2
                    : 0,
                child: RotationTransition(
                  turns: (sideBarActive)
                      ? Tween(begin: -0.05, end: 0.0)
                          .animate(rotationController)
                      : Tween(begin: 0.0, end: -0.05)
                          .animate(rotationController),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: (sideBarActive)
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height,
                    width: (sideBarActive)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: sideBarActive
                          ? const BorderRadius.all(Radius.circular(40))
                          : const BorderRadius.all(Radius.circular(0)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: ClipRRect(
                      borderRadius: sideBarActive
                          ? const BorderRadius.all(Radius.circular(40))
                          : const BorderRadius.all(Radius.circular(0)),
                      child: Column(
                        children: [
                          Expanded(child: widget.child),
                          widget.bottomBar ?? const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Builder(builder: (context) {
                return Positioned(
                  right: 0,
                  top: 20,
                  child: (sideBarActive)
                      ? IconButton(
                          padding: const EdgeInsets.all(30),
                          onPressed: () =>
                              context.read<DrawerCubit>().closeDrawer(),
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                        )
                      : const SizedBox(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Row navigatorTitle(String name, bool isSelected) {
    return Row(
      children: [
        (isSelected)
            ? Container(
                width: 5,
                height: 40,
                color: const Color(0xffffac30),
              )
            : const SizedBox(
                width: 5,
                height: 40,
              ),
        const SizedBox(
          width: 10,
          height: 45,
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16,
                fontWeight: (isSelected) ? FontWeight.w700 : FontWeight.w400,
              ),
        ),
      ],
    );
  }

  void closeSideBar() {
    sideBarActive = false;
    setState(() {});
  }

  void openSideBar() {
    sideBarActive = true;
    setState(() {});
  }
}
