import 'package:flutter/material.dart';
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
    //agregarAnimal();
    //agregarAve();
  }

  // Animal methods


  void eliminarAnimal(int index) {
    if (animales.length > 1 && index >= 0 && index < animales.length) {
      // Dispose de los controllers del animal que se va a eliminar
      // final animalAEliminar = animales[index];
      // animalAEliminar.dispose(); // Descomenta cuando tengas el método dispose en AnimalModel
      
      animales.removeAt(index);
      print('Animal eliminado. Total animales: ${animales.length}'); // Debug
      notifyListeners();
    }
  }
  
void agregarAnimal(AnimalModel nuevoAnimal) {
  animales.add(nuevoAnimal);
  notifyListeners();
}

void actualizarAnimal(int index, AnimalModel updatedAnimal) {
  if (index >= 0 && index < animales.length) {
    // Dispose del animal antiguo
    animales[index].dispose();
    
    // Asignar el nuevo animal
    animales[index] = updatedAnimal;
    notifyListeners();
  }
}
  

  // Ave methods
void agregarAve() {
  try {
    final nuevaAve = AveModel();
    aves.add(nuevaAve);
    debugPrint('Ave agregada. Total aves: ${aves.length}');
    
    // Notifica dos veces para asegurar la actualización
    notifyListeners();
    Future.delayed(Duration.zero, () => notifyListeners());
  } catch (e) {
    debugPrint('Error al agregar ave: $e');
  }
}

void actualizarAve(int index, AveModel updatedAve) {
  if (index >= 0 && index < aves.length) {
    aves[index].dispose();
    aves[index] = updatedAve;
    notifyListeners();
  }
}

void eliminarAve(int index) {
  if (aves.length > 1 && index >= 0 && index < aves.length) {
    aves[index].dispose(); // Properly dispose the controllers
    aves.removeAt(index);
    debugPrint('Ave eliminada. Total aves: ${aves.length}');
    notifyListeners();
  }
}



  // Método para validar si hay al menos un animal
  bool tieneAnimales() {
    return animales.isNotEmpty;
  }

  // Método para limpiar todos los datos
  void limpiarDatos() {
    // Dispose de todos los controllers
    // for (var animal in animales) {
    //   animal.dispose(); // Descomenta cuando tengas el método dispose
    // }
    // for (var ave in aves) {
    //   ave.dispose(); // Descomenta cuando tengas el método dispose
    // }
    
    animales.clear();
    aves.clear();
    
    // Reinicializar con un animal
    //agregarAnimal();
    
    // Limpiar otros modelos (si tienen TextEditingController, límpialos aquí)
    // predioModel.limpiar(); // Comentado hasta que implementes el método
    // transporteModel.limpiar(); // Comentado hasta que implementes el método
    
    notifyListeners();
  }

  // Form submission
  Future<void> enviarSolicitud(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos requeridos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que hay al menos un animal o ave
    if (animales.isEmpty && aves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe agregar al menos un animal o ave'),
          backgroundColor: Colors.orange,
        ),
      );
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
          'total_animales': animales.length,
          'total_aves': aves.length,
        },
      };

      // Imprimir en consola el JSON de datos que se enviará
      print('Datos a enviar: $datos');

      final response = await ApiService.enviarSolicitud(datos);
      print('Respuesta backend: $response');

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada exitosamente'),
          backgroundColor: Colors.green, // Cambiado a verde para éxito
        ),
      );

      // Limpiar formulario después del éxito
      limpiarDatos();
      formKey.currentState?.reset();
      await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éxito'),
        content: const Text('La solicitud se registró correctamente'),
        actions: [
          TextButton(
            child: const Text('Ver solicitudes'),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/viewRequests',
              (route) => false,
            ),
          ),
          TextButton(
            child: const Text('Nueva solicitud'),
            onPressed: () {
              limpiarDatos();
              formKey.currentState?.reset();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
      
    } catch (e) {
      String errorMessage = 'Error al enviar solicitud';

      if (e is ApiException) {
        errorMessage = e.message ?? errorMessage;
        if (e.statusCode == 400) {
          errorMessage = 'Datos incompletos o incorrectos. Verifique toda la información.';
        } else if (e.statusCode == 500) {
          errorMessage = 'Error del servidor. Intente nuevamente más tarde.';
        } else if (e.statusCode == 401) {
          errorMessage = 'No autorizado. Verifique sus credenciales.';
        }
      } else {
        errorMessage = 'Error de conexión. Verifique su internet.';
      }

      print('Error al enviar solicitud: $e'); // Debug

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () => enviarSolicitud(context),
          ),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Dispose de todos los controllers antes de destruir el controller
     for (var animal in animales) {
     animal.dispose(); // Descomenta cuando tengas el método dispose
     }
     for (var ave in aves) {
       ave.dispose(); // Descomenta cuando tengas el método dispose
    }
    scrollController.dispose();
    super.dispose();
  }
}