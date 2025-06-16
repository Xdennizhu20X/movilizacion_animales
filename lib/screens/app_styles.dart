import 'package:flutter/material.dart';

class AppStyles {
  // Colores corporativos
  static const Color amarillo = Color(0xFFFFD100);
  static const Color azul = Color(0xFF003399);
  static const Color rojo = Color(0xFFCE1126);
  static const Color grisClaro = Color(0xFFF5F5F5);
  static const Color blanco = Colors.white;
  static const Color negro = Colors.black;

  // Espaciados
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadiusSmall = 10.0;
  static const double borderRadiusMedium = 20.0;

  // Estilo de texto base
  static TextStyle textStyle({
    double size = 16,
    Color color = Colors.black,
    FontWeight weight = FontWeight.normal,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Decoración de inputs
  static InputDecoration inputDecoration(
    String label, {
    IconData? icon,
    Widget? suffixIcon,
    String? hintText,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: icon != null ? Icon(icon, color: azul) : null,
      suffixIcon: suffixIcon,
      labelStyle: textStyle(color: azul),
      hintStyle: textStyle(color: Colors.grey),
      errorStyle: textStyle(color: rojo, size: 14),
      filled: true,
      fillColor: grisClaro,
      contentPadding: EdgeInsets.symmetric(
        vertical: paddingMedium,
        horizontal: paddingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(color: azul.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(color: azul.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(color: rojo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(color: rojo),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(color: rojo, width: 2),
      ),
    );
  }

  // Estilo de botones elevados
  static ButtonStyle elevatedButtonStyle({
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? amarillo,
      foregroundColor: azul,
      elevation: elevation ?? 2,
      padding: padding ?? EdgeInsets.symmetric(
        vertical: paddingMedium,
        horizontal: paddingLarge,
      ),
      minimumSize: minimumSize ?? Size(88, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      textStyle: textStyle(weight: FontWeight.bold),
    );
  }

  // Estilo de botones de texto
  static ButtonStyle textButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: azul,
      padding: EdgeInsets.symmetric(
        vertical: paddingMedium,
        horizontal: paddingLarge,
      ),
      textStyle: textStyle(weight: FontWeight.bold),
    );
  }

  // Estilo de radio buttons
  static Widget radioButton(
    String value,
    String label,
    String? groupValue,
    Function(String?) onChanged, {
    bool isError = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: rojo,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: textStyle()),
      ],
    );
  }

  // Estilo de checkboxes
  static Widget checkbox(
    String label,
    bool value,
    Function(bool?) onChanged, {
    bool isError = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: azul,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: textStyle()),
      ],
    );
  }

  // Estilo de cards
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: blanco,
      borderRadius: BorderRadius.circular(borderRadiusSmall),
      border: Border.all(color: azul.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  // Estilo de app bar
  static AppBarTheme appBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: azul,
      titleTextStyle: textStyle(
        size: 20,
        color: blanco,
        weight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: blanco),
    );
  }
}