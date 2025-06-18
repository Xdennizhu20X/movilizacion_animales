import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ViewRequestsScreen extends StatefulWidget {
  @override
  _ViewRequestsScreenState createState() => _ViewRequestsScreenState();
}

class _ViewRequestsScreenState extends State<ViewRequestsScreen> {
  static const Color primaryPurple = Color(0xFF6e328a);
  static const Color whiteColor = Colors.white;
  static const Color secondaryText = Color(0xFF4A4A4A);
  
  List<dynamic> movilizaciones = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarMovilizaciones();
  }

  Future<void> _cargarMovilizaciones() async {
    try {
      final data = await ApiService.obtenerMisMovilizaciones();
      setState(() {
        movilizaciones = data;
        isLoading = false;
        
        // Ordenar por fecha más reciente primero
        movilizaciones.sort((a, b) {
          final dateA = DateTime.parse(a['fecha_solicitud'] ?? '1970-01-01');
          final dateB = DateTime.parse(b['fecha_solicitud'] ?? '1970-01-01');
          return dateB.compareTo(dateA);
        });
      });
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error inesperado al cargar las movilizaciones';
        isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Mis Movilizaciones',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: primaryPurple,
        elevation: 4,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(
                    errorMessage,
                    style: TextStyle(color: secondaryText),
                  ))
                : movilizaciones.isEmpty
                    ? Center(child: Text(
                        'No tienes movilizaciones registradas',
                        style: TextStyle(color: secondaryText),
                      ))
                    : RefreshIndicator(
                        onRefresh: _cargarMovilizaciones,
                        child: ListView.builder(
                          itemCount: movilizaciones.length,
                          itemBuilder: (context, index) {
                            final mov = movilizaciones[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  // Navegar a pantalla de detalle
                                  // Navigator.push(context, MaterialPageRoute(
                                  //   builder: (context) => RequestDetailScreen(movilizacionId: mov['id']),
                                  // ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Solicitud del ${_formatDate(mov['fecha_solicitud'])}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryPurple,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (mov['predio_origen'] != null)
                                        Text(
                                          'Origen: ${mov['predio_origen']['nombre']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: secondaryText,
                                          ),
                                        ),
                                      if (mov['predio_destino'] != null)
                                        Text(
                                          'Destino: ${mov['predio_destino']['nombre']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: secondaryText,
                                          ),
                                        ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Chip(
                                            label: Text(
                                              mov['estado']?.toString().toUpperCase() ?? 'DESCONOCIDO',
                                              style: const TextStyle(color: whiteColor),
                                            ),
                                            backgroundColor: _getStatusColor(mov['estado']?.toString() ?? ''),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Navegar a pantalla de detalle
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryPurple.withOpacity(0.1),
                                              foregroundColor: primaryPurple,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                            ),
                                            child: const Text('Ver Detalles'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}