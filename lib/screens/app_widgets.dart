import 'package:flutter/material.dart';
import 'app_styles.dart';
import 'package:intl/intl.dart';

class AppWidgets {
  // Widget de sección con título
  static Widget buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration(),
      margin: EdgeInsets.only(bottom: AppStyles.paddingMedium),
      padding: padding ?? EdgeInsets.all(AppStyles.paddingMedium),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            children: [
              Icon(icon, color: AppStyles.rojo),
              SizedBox(width: AppStyles.paddingSmall),
              Text(
                title,
                style: AppStyles.textStyle(
                  size: 18,
                  color: AppStyles.azul,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            color: AppStyles.azul.withOpacity(0.3),
            thickness: 1,
            height: AppStyles.paddingMedium,
          ),
          SizedBox(height: AppStyles.paddingSmall),
          ...children,
        ],
      ),
    );
  }

  // Widget de botón con icono
  static Widget iconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? iconColor,
    Color? labelColor,
    Color? backgroundColor,
    double? iconSize,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: iconColor ?? AppStyles.azul,
        size: iconSize ?? 24,
      ),
      label: Text(
        label,
        style: AppStyles.textStyle(color: labelColor ?? AppStyles.azul),
      ),
      style: AppStyles.elevatedButtonStyle(
        backgroundColor: backgroundColor ?? AppStyles.amarillo,
        padding: padding,
      ),
      onPressed: onPressed,
    );
  }

  // Widget de campo de fecha
  static Widget dateField({
    required BuildContext context,
    required DateTime date,
    required ValueChanged<DateTime> onDateChanged,
    String label = 'Fecha',
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRequired)
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('*', style: AppStyles.textStyle(color: AppStyles.rojo)),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.calendar_today, color: AppStyles.azul),
          title: Text(label),
          subtitle: Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: AppStyles.textStyle(),
          ),
          trailing: ElevatedButton(
            style: AppStyles.elevatedButtonStyle(),
            child: Text(
              'Seleccionar',
              style: AppStyles.textStyle(color: AppStyles.azul),
            ),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppStyles.azul,
                        onPrimary: AppStyles.blanco,
                        surface: AppStyles.blanco,
                        onSurface: AppStyles.negro,
                      ),
                      dialogBackgroundColor: AppStyles.blanco,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != date) {
                onDateChanged(picked);
              }
            },
          ),
        ),
      ],
    );
  }

  // Widget de dropdown personalizado
  static Widget dropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String label,
    String? hint,
    String? errorText,
    bool isExpanded = true,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: AppStyles.inputDecoration(
        label,
        hintText: hint,
        errorText: errorText,
      ),
      isExpanded: isExpanded,
      style: AppStyles.textStyle(),
      icon: Icon(Icons.arrow_drop_down, color: AppStyles.azul),
      borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
    );
  }

  // Widget de lista vacía
  static Widget emptyList({
    required String message,
    IconData icon = Icons.info_outline,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppStyles.azul.withOpacity(0.5)),
          SizedBox(height: AppStyles.paddingMedium),
          Text(
            message,
            style: AppStyles.textStyle(
              color: AppStyles.azul.withOpacity(0.7),
              size: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget de loading
  static Widget loadingIndicator({Color? color}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppStyles.azul),
      ),
    );
  }
}