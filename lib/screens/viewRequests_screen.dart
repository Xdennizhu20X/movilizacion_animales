import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import 'app_widgets.dart';

class ViewRequestsScreen extends StatefulWidget {
  const ViewRequestsScreen({super.key});

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
  bool isDownloading = false;
  int? downloadingId;

  @override
  void initState() {
    super.initState();
    _cargarMovilizaciones();
  }

  Future<void> _cargarMovilizaciones() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final onlineMovilizaciones = await ApiService.obtenerMisMovilizaciones();

      setState(() {
        movilizaciones = onlineMovilizaciones;
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
        errorMessage = 'Error inesperado al cargar las movilizaciones: $e';
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
      case 'finalizada':
        return Colors.green[700]!;
      case 'local':
        return Colors.blue;
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

  Future<void> _descargarCertificado(int movilizacionId) async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
      downloadingId = movilizacionId;
    });

    try {
      await ApiService.descargarCertificadoPdf(movilizacionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF descargado correctamente')),
      );
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al procesar la descarga'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Detalles',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error detallado'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
          downloadingId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const CustomAppBar(title: 'Mis Movilizaciones'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const LogoHeader(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                          errorMessage,
                          style: TextStyle(color: secondaryText),
                        ))
                      : movilizaciones.isEmpty
                          ? Center(
                              child: Text(
                              'No tienes movilizaciones registradas',
                              style: TextStyle(color: secondaryText),
                            ))
                          : RefreshIndicator(
                              onRefresh: _cargarMovilizaciones,
                              child: ListView.builder(
                                itemCount: movilizaciones.length,
                                itemBuilder: (context, index) {
                                  final mov = movilizaciones[index];
                                  final isCurrentDownloading =
                                      isDownloading && downloadingId == mov['id'];

                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
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
                                                  mov['estado']?.toString().toUpperCase() ??
                                                      'DESCONOCIDO',
                                                  style: const TextStyle(color: whiteColor),
                                                ),
                                                backgroundColor: _getStatusColor(
                                                    mov['estado']?.toString() ?? ''),
                                              ),
                                              if (mov['estado'] != 'local')
                                                ElevatedButton(
                                                  onPressed: isCurrentDownloading
                                                      ? null
                                                      : () => _descargarCertificado(mov['id']),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primaryPurple.withOpacity(0.1),
                                                    foregroundColor: primaryPurple,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                  ),
                                                  child: isCurrentDownloading
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<Color>(
                                                                    primaryPurple),
                                                          ),
                                                        )
                                                      : const Text('Descargar PDF'),
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
          ],
        ),
      ),
    );
  }
}
