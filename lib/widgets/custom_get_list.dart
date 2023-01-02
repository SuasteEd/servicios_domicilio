import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';
import 'package:servicios_domicilio/models/tecnico_model.dart';

class CustomGetList extends StatefulWidget {
  const CustomGetList({Key? key}) : super(key: key);

  @override
  _CustomGetListState createState() => _CustomGetListState();
}

class _CustomGetListState extends State<CustomGetList> {
  final controller = Get.put(ServiciosController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tecnicos = controller.servicios;
    return Obx(
      () {
        final itemCount = controller.servicios.length;
        return itemCount == 0
            ? datos()
            : RefreshIndicator(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
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
                  datos();
                  setState(() {});
                  return controller.getServicio();
                });
      },
    );
  }

  Widget datos() {
    if (controller.connection.isFalse) {
      return GestureDetector(
        onTap: () => controller.getServicio(),
        child: const Center(
          child: Text('No hay conexión a internet'),
        ),
      );
    }

    // if (controller.servicios.isEmpty) {
    //   return GestureDetector(
    //     onTap: () => controller.getServicio(),
    //     child: const Text('No hay datos para mostrar'),
    //   );
    //}

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
