import 'package:flutter/material.dart';

class ViewRequestsScreen extends StatelessWidget {
  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);

  // Simulación de datos de solicitudes
  final List<Map<String, dynamic>> requests = [
    {
      'date': '2025-05-30',
      'status': 'Aprobada',
    },
    {
      'date': '2025-05-28',
      'status': 'Pendiente',
    },
    {
      'date': '2025-05-25',
      'status': 'Rechazada',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprobada':
        return Colors.green;
      case 'Pendiente':
        return Colors.orange;
      case 'Rechazada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitud del ${request['date']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blueColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            request['status'],
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(request['status']),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para ver detalles
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowColor,
                          ),
                          child: Text(
                            'Ver Solicitud',
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
    );
  }
}
