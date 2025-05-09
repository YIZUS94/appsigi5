class Insumo {
  final String nombre;
  final double cantidad;
  final String unidadMedida;
  final DateTime fechaCompra;
  final String marca;
  final double costo;
  final String etapaPuerco;

  Insumo({
    required this.nombre,
    required this.cantidad,
    required this.unidadMedida,
    required this.fechaCompra,
    required this.marca,
    required this.costo,
    required this.etapaPuerco,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'unidadMedida': unidadMedida,
      'fechaCompra': fechaCompra.toIso8601String(),
      'marca': marca,
      'costo': costo,
      'etapaPuerco': etapaPuerco,
    };
  }

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      nombre: json['nombre'],
      cantidad: (json['cantidad'] as num).toDouble(),
      unidadMedida: json['unidadMedida'],
      fechaCompra: DateTime.parse(json['fechaCompra']),
      marca: json['marca'],
      costo: (json['costo'] as num).toDouble(),
      etapaPuerco: json['etapaPuerco'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Insumo &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre &&
          cantidad == other.cantidad &&
          unidadMedida == other.unidadMedida &&
          fechaCompra == other.fechaCompra &&
          marca == other.marca &&
          costo == other.costo &&
          etapaPuerco == other.etapaPuerco;

  @override
  int get hashCode =>
      nombre.hashCode ^
      cantidad.hashCode ^
      unidadMedida.hashCode ^
      fechaCompra.hashCode ^
      marca.hashCode ^
      costo.hashCode ^
      etapaPuerco.hashCode;
}