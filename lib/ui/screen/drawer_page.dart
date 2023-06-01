import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:sun_point/logic/controllers/drawer.dart';
import 'package:sun_point/ui/widgets/yes_no_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';

class DrawerPage extends StatefulWidget {
  final Widget child;
  final Widget? bottomBar;
  final String current;
  DrawerPage({
    Key? key,
    required this.child,
    this.bottomBar,
    required this.current,
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
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
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
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: snap.data!.avatar == null
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.4,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                ),
                                                child: const Icon(
                                                  Icons.person_outlined,
                                                  size: 25,
                                                ),
                                              )
                                            : SizedBox.square(
                                                dimension: 50,
                                                child: Image.network(
                                                  snap.data!.avatar!,
                                                  fit: BoxFit.cover,
                                                ),
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
                        navigatorTitle("Home", Routes.home),
                        navigatorTitle("Profile", Routes.profile),
                        navigatorTitle("Account", Routes.account),
                        navigatorTitle("Transactions", Routes.history),
                        navigatorTitle("Stats", ""),
                        navigatorTitle("Settings", ""),
                        navigatorTitle("Help", ""),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () async {
                        bool? res = await showDialog(
                            context: context,
                            builder: (_) => const YesNoDialog(
                                title: 'Logout', text: 'logoutAsk'));
                        if (res == true) {
                          await User.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.mainAuth, (route) => false);
                        }
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
                  FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const SizedBox();
                        }
                        return Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Ver",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ).tr(args: [snap.data!.version]),
                        );
                      })
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

  Widget navigatorTitle(String name, String route) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(route, (route) => false),
      child: Row(
        children: [
          (widget.current == route)
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
                  fontWeight: (widget.current == route)
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
          ),
        ],
      ),
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
