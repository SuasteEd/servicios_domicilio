import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:servicios_domicilio/constants/constants.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:servicios_domicilio/widgets/custom_get_list.dart';
import 'package:servicios_domicilio/widgets/widgets.dart';

import '../controllers/servicios_controller.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final date = DateTime.now();
  final controller = Get.put(ServiciosController());

  @override
  void initState() {
    getCurrentLocation();
    Get.put(ServiciosController()).getServicio();
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    //Ensure all permissions are collected for location
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionsGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionsGranted = await location.hasPermission();
    if (permissionsGranted == PermissionStatus.denied) {
      permissionsGranted = await location.requestPermission();
    }

    //Get the current user location
    LocationData locationData = await location.getLocation();
    //Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);

    //print(locationData.latitude);
    //print(locationData.altitude);
  }

  @override
  Widget build(BuildContext context) {
    //AppBar
    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: AppTheme.primary,
      title: FadeInDown(child: Text('${months[date.month - 1]} ${date.day}')),
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
              icon: const Icon(Icons.scatter_plot),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        },
      ),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.schedule))],
    );

    //Scaffold
    return Scaffold(
      appBar: appBar,
      backgroundColor: AppTheme.primary,
      drawer: const DrawerWidget(),
      body: const SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: _Header(),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final controller = Get.put(ServiciosController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: FadeInLeft(
                        child: const Text(
                          'Hoy',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: FadeInLeft(
                        child: const Text(
                          'Tus entregas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: FadeInRight(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        controller.getServicio();
                        setState(() {});
                      },
                      child: Ink(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                            child: Text('Refrescar',
                                style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FadeInUp(child: const _EntregasList()),
      ],
    );
  }
}

class _EntregasList extends StatelessWidget {
  const _EntregasList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height - 230,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              child: SizedBox(height: 580, child: CustomGetList()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiasList extends StatefulWidget {
  const _DiasList();

  @override
  State<_DiasList> createState() => _DiasListState();
}

class _DiasListState extends State<_DiasList> {
  final controller = Get.put(ServiciosController());
  final date = DateTime.now();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.servicios.length,
      itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(0),
        height: 120,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  current = index;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color:
                              current == index ? AppTheme.primary : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.servicios[index].fecha.day
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                days[controller.servicios[index].fecha.weekday -
                                    1],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(''),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
