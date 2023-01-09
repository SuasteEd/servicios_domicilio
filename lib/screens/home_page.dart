// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/constants/constants.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:servicios_domicilio/widgets/custom_get_list.dart';
import 'package:servicios_domicilio/widgets/widgets.dart';

import '../controllers/servicios_controller.dart';

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
    Get.put(ServiciosController()).getServicio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //AppBar
    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: AppTheme.primary,
      title: Text('${months[date.month - 1]} ${date.day}'),
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
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Hoy',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Tus entregas',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
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
              ],
            ),
          ),
        ),
        const _EntregasList(),
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
          children: [
            // Container(
            //   height: 120,
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
            //     //color: Colors.amber,
            //   ),
            //   child: const Center(
            //     child: Padding(
            //         padding: EdgeInsets.only(left: 20), child: _DiasList()),
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            const SingleChildScrollView(
              child: SizedBox(height: 580, child: CustomGetList()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refresh() async {
    print('Refrescante');
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
