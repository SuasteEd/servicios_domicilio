import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';

import '../services/network_service.dart';

class CustomGetList extends StatefulWidget {
  const CustomGetList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomGetListState createState() => _CustomGetListState();
}

class _CustomGetListState extends State<CustomGetList> {
  final controller = Get.put(ServiciosController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tecnicos = controller.servicios;
    return Obx(
      () {
        final itemCount = controller.servicios.length;
        return itemCount == 0
            ? datos(context)
            : RefreshIndicator(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tecnicos.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  Text(
                                    tecnicos[index].horario,
                                    style: const TextStyle(
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
                ),
                onRefresh: () {
                  setState(() {});
                  return controller.getServicio();
                });
      },
    );
  }

  Widget datos(BuildContext context) {
    final connection = Provider.of<NetworkStatus>(context);
    if (connection == NetworkStatus.offline) {
      return GestureDetector(
        onTap: () => {this, setState(() {}), controller.getServicio()},
        child: Column(
          children: const [
            FadeInImage(
              placeholder: AssetImage('assets/connection.png'),
              image: AssetImage('assets/connection.png'),
              width: 300,
              height: 400,
            ),
            Text('Sin conexión a internet')
          ],
        ),
      );
    }

    if (controller.loading.isTrue && controller.servicios.isEmpty) {
      return GestureDetector(
        onTap: () => {this, setState(() {}), controller.getServicio()},
        child: Column(
          children: const [
            FadeInImage(
              placeholder: AssetImage('assets/nada.png'),
              image: AssetImage('assets/nada.png'),
              width: 300,
              height: 400,
            ),
            Text('No hay entregas')
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  String status(int index) {
    switch (controller.servicios[index].estado) {
      case 0:
        {
          return 'Completado';
        }
      case 1:
        {
          return 'En curso';
        }
      case 2:
        {
          return 'Cancelado';
        }
      default:
        break;
    }
    return '';
  }

  Color color(int index) {
    switch (controller.servicios[index].estado) {
      case 0:
        {
          return Colors.green;
        }
      case 1:
        {
          return Colors.grey;
        }
      case 2:
        {
          return Colors.red;
        }
      default:
        break;
    }
    return Colors.white;
  }
}
