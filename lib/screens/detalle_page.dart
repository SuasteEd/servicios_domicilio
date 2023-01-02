import 'package:flutter/material.dart';
import 'package:servicios_domicilio/models/tecnico_model.dart';
import 'package:servicios_domicilio/services/tecnico_response.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';

class DetallePage extends StatelessWidget {
  const DetallePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final ServicioElement tec =
        ModalRoute.of(context)!.settings.arguments as ServicioElement;
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        title: const Text('Detalle'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          //Cliente y folio
          _Title(tec: tec),
          //Demás elementos
          _Card(
            tec: tec,
          )
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final ServicioElement tec;
  const _Card({
    Key? key,
    required this.tec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(45),
      ),
    );

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: boxDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Domicilio:',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                tec.domicilio,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Fecha:',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${tec.fecha.day}/${tec.fecha.month}/${tec.fecha.year}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Horario',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(tec.horario,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final ServicioElement tec;
  const _Title({
    Key? key,
    required this.tec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: size.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tec.cliente,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Text(
              'No. folio ${tec.folio}',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
