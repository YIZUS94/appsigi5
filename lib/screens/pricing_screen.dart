import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  String _selectedCurrency = 'MXN'; // Moneda por defecto
  final Map<String, Map<String, dynamic>> _costs = {
    'MXN': {
      'Lechones': 50.00,
      'Crecimiento': 120.00,
      'Engorde': 180.00,
      'Reproducción': 300.00,
    },
    'USD': {
      'Lechones': 2.95,
      'Crecimiento': 7.08,
      'Engorde': 10.62,
      'Reproducción': 17.70,
    },
    'EUR': {
      'Lechones': 2.75,
      'Crecimiento': 6.60,
      'Engorde': 9.90,
      'Reproducción': 16.50,
    },
  };

  double _getCostInSelectedCurrency(String stage) {
    if (_costs.containsKey(_selectedCurrency) && _costs[_selectedCurrency]!.containsKey(stage)) {
      return _costs[_selectedCurrency]![stage] as double;
    } else {
      return 0.0; // Valor por defecto si no se encuentra el costo
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'MXN':
      default:
        return '\$';
    }
  }

  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  final List<Color> _sliderColors = [
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
    Colors.teal[100]!,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      // Comentamos el cambio automático para usar los botones manuales
      // if (_factorTexts.isNotEmpty) {
      //   print("PageController.page: ${_pageController.page}");
      //   int nextPage = (_pageController.page?.round() ?? 0) + 1;
      //   if (nextPage >= _factorTexts.length) {
      //     nextPage = 0;
      //   }
      //   _pageController.animateToPage(
      //     nextPage,
      //     duration: const Duration(milliseconds: 500),
      //     curve: Curves.easeInOut,
      //   );
      //   if (mounted) {
      //     setState(() {});
      //   }
      // }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _factorTexts = const [
    'Dinámica de la Oferta y la Demanda: Fluctuaciones en la producción y la demanda del consumidor.',
    'Costos de Insumos: Variaciones en los precios de alimentación, energía, medicamentos, etc.',
    'Condiciones del Mercado y Competencia: Estructura del mercado y estrategias de precios.',
    'Políticas Gubernamentales y Regulaciones: Subsidios, impuestos, normas sanitarias y ambientales.',
    'Factores Estacionales y Eventos Específicos: Cambios en la demanda por temporadas.',
  ];

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precios y Costos'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedCurrency,
              items: _costs.keys.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Factores que Influyen en el Precio del Cerdo'),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _factorTexts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: _sliderColors[index % _sliderColors.length],
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                _factorTexts[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: _goToPreviousPage,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: _goToNextPage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Costos Estimados por Etapa de Crecimiento (por día)'),
              const SizedBox(height: 16),
              _buildCostItem('Lechones (hasta 8 semanas)', 'Lechones', FontAwesomeIcons.piggyBank, context),
              _buildCostItem('Crecimiento (8-20 semanas)', 'Crecimiento', FontAwesomeIcons.child, context),
              _buildCostItem('Engorde (20 semanas hasta el sacrificio)', 'Engorde', FontAwesomeIcons.bacon, context),
              _buildCostItem('Reproducción (cerdas y verracos)', 'Reproducción', FontAwesomeIcons.female, context),
              const SizedBox(height: 24),
              const Text(
                'Nota: Estos son costos estimados y pueden variar según diversos factores.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Información Adicional'),
              const SizedBox(height: 16),
              _buildPriceInfoCardWithIcon('Precio de venta promedio por cabeza (al sacrificio):', '${_getCurrencySymbol(_selectedCurrency)} 2500.00', FontAwesomeIcons.dollarSign, context),
              const SizedBox(height: 16),
              // La sección de factores ahora está arriba con su título y botones
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    );
  }

  Widget _buildCostItem(String etapaText, String stageKey, IconData icon, BuildContext context) {
    final cost = _getCostInSelectedCurrency(stageKey).toStringAsFixed(2);
    final currencySymbol = _getCurrencySymbol(_selectedCurrency);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$etapaText (por día)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('$_selectedCurrency $currencySymbol$cost por animal', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }

  Widget _buildPriceInfoCardWithIcon(String label, String value, IconData icon, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(value, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}