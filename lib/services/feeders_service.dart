class FeedersService {
  // Aquí implementarías la conexión con tu API o backend
  Future<void> addFeeder(String name) async {
    // Lógica para agregar comedero
  }

  Future<void> removeFeeder(String name) async {
    // Lógica para eliminar comedero
  }

  Future<List<String>> getFeeders() async {
    // Lógica para obtener lista de comederos
    return ['Comedero 1', 'Comedero 2', 'Comedero 3'];
  }
}