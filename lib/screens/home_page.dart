import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/constants/constants.dart';
import 'package:servicios_domicilio/models/static_tecnicos.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:servicios_domicilio/widgets/custom_get_list.dart';
import 'package:servicios_domicilio/widgets/widgets.dart';

import '../controllers/servicios_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: _Header(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  _Header();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiciosController());
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 50),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pushNamed(context, 'animation');
                //     },
                //     child: Container(
                //       width: 120,
                //       height: 50,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: const Center(
                //           child: Text('Agregar',
                //               style: TextStyle(
                //                   color: AppTheme.primary,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 16))),
                //     ),
                //   ),
                // ),
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
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
            //       color: Colors.amber),
            //   child: const Center(
            //     child: Padding(
            //         padding: EdgeInsets.only(left: 20), child: _DiasList()),
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            const SingleChildScrollView(
              child: SizedBox(
                height: 580,
                child: CustomGetList(),
              ),
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

class _CustomCards extends StatelessWidget {
  const _CustomCards();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: tecnicos.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: color(index),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'detalle',
                    arguments: tecnicos[index]);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 232, 237, 243),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Folio: ${tecnicos[index].folio}',
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: color(index),
                                size: 10,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(status(index))
                            ],
                          ),
                        ],
                      ),
                      Text(
                        tecnicos[index].cliente,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        '10:00 - 11:30',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
                                '${controller.servicios[index].horario}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                days[horario[index].diaSema],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(horario[index].horario),
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

String status(int index) {
  switch (tecnicos[index].estado) {
    case 1:
      {
        return 'Completado';
      }
    case 2:
      {
        return 'En curso';
      }
    case 3:
      {
        return 'Cancelado';
      }
    default:
      break;
  }
  return '';
}

Color color(int index) {
  switch (tecnicos[index].estado) {
    case 1:
      {
        return Colors.green;
      }
    case 2:
      {
        return Colors.grey;
      }
    case 3:
      {
        return Colors.red;
      }
    default:
      break;
  }
  return Colors.white;
}
