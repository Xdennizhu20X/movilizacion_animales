import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ViewRequestsScreen extends StatefulWidget {
  @override
  _ViewRequestsScreenState createState() => _ViewRequestsScreenState();
}

class _ViewRequestsScreenState extends State<ViewRequestsScreen> {
  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);
  
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
      appBar: AppBar(
        title: Text('Mis Movilizaciones'),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : movilizaciones.isEmpty
                    ? Center(child: Text('No tienes movilizaciones registradas'))
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
                              margin: EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Solicitud del ${_formatDate(mov['fecha_solicitud'])}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: blueColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    if (mov['predio_origen'] != null)
                                      Text(
                                        'Origen: ${mov['predio_origen']['nombre']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    if (mov['predio_destino'] != null)
                                      Text(
                                        'Destino: ${mov['predio_destino']['nombre']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Chip(
                                          label: Text(
                                            mov['estado']?.toString().toUpperCase() ?? 'DESCONOCIDO',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor:
                                              _getStatusColor(mov['estado']?.toString() ?? ''),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navegar a pantalla de detalle
                                            // Navigator.push(context, MaterialPageRoute(
                                            //   builder: (context) => RequestDetailScreen(movilizacionId: mov['id']),
                                            // ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: yellowColor,
                                          ),
                                          child: Text(
                                            'Ver Detalles',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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