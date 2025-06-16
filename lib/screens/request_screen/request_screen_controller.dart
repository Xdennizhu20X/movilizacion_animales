import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/animal_model.dart';
import '../../models/ave_model.dart';
import '../../models/predio_model.dart';
import '../../models/transporte_model.dart';
import '../../services/api_service.dart';

class RequestScreenController extends ChangeNotifier {
  // Form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  // Models
  final PredioModel predioModel = PredioModel();
  final TransporteModel transporteModel = TransporteModel();
  final List<AnimalModel> animales = [];
  final List<AveModel> aves = [];

  // State
  bool isLoading = false;

  // Initialize with one animal and one ave
  RequestScreenController() {
    agregarAnimal();
    //agregarAve();
  }

  // Animal methods
  void agregarAnimal() {
    animales.add(AnimalModel());
    notifyListeners();
  }

  void eliminarAnimal(int index) {
    if (animales.length > 1) {
      animales.removeAt(index);
      notifyListeners();
    }
  }

  // Ave methods
  void agregarAve() {
    aves.add(AveModel());
    notifyListeners();
  }

  void eliminarAve(int index) {
    if (aves.length > 1) {
      aves.removeAt(index);
      notifyListeners();
    }
  }

  // Form submission
  Future<void> enviarSolicitud(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final datos = {
        'fecha': DateTime.now().toIso8601String().split('T')[0],
        'animales': animales.map((animal) => animal.toJson()).toList(),
        'aves': aves.map((ave) => ave.toJson()).toList(),
        'predio_origen': predioModel.toJsonPredioOrigen(),
        'destino': predioModel.toJsonDestino(),
        'transporte': transporteModel.toJson(),
        'datos_adicionales': {
          'observaciones_generales': predioModel.observacionesGenerales,
        },
      };

      // Imprimir en consola el JSON de datos que se enviará
      print('Datos a enviar: ${datos}');

      final response = await ApiService.enviarSolicitud(datos);
      print('Respuesta backend: $response'); // <- Asegúrate de imprimir esto

      // Mostrar mensaje JSON de éxito
      final resultado = {
        'status': 'success',
        'message': 'Datos enviados exitosamente',
      };
      print('Respuesta: $resultado');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada exitosamente'),
          backgroundColor: Colors.red,
        ),
      );

      formKey.currentState?.reset();
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = 'Error al enviar solicitud';

      if (e is ApiException) {
        errorMessage = e.message ?? errorMessage;
        if (e.statusCode == 400) {
          errorMessage =
              'Datos incompletos o incorrectos. Verifique toda la información.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
