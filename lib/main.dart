import 'package:flutter/material.dart';

void main() => runApp(const CafeCalcApp());

class CafeCalcApp extends StatelessWidget {
  const CafeCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    const coffee = Color(0xFFB87942);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CaféCalc',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: coffee,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF18130F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17141A),
          foregroundColor: Color(0xFFF5EEE8),
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _priceController = TextEditingController(text: '16000');
  final _cansController = TextEditingController(text: '33');
  final _benefitController = TextEditingController(text: '15');
  final _poundsController = TextEditingController(text: '30');

  double _number(TextEditingController controller) {
    final normalized = controller.text.trim().replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  double get _averagePrice => _number(_priceController) / _number(_cansController);
  double get _pricePerCan => _averagePrice - _number(_benefitController);
  double get _pricePerPound => _pricePerCan / _number(_poundsController);

  String _format(double value) => value.toStringAsFixed(2);

  Widget _headerCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );

  Widget _detailCell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

  Widget _valueCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Text(text, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16)),
      );

  Widget _inputCell(TextEditingController controller, {bool highlighted = false}) {
    return Container(
      color: highlighted ? const Color(0xFFFFFF00) : null,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerRight,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          fontSize: 16,
          color: highlighted ? Colors.black : const Color(0xFFF5EEE8),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  TableRow _row(Widget units, Widget detail) => TableRow(children: [units, detail]);

  @override
  void dispose() {
    _priceController.dispose();
    _cansController.dispose();
    _benefitController.dispose();
    _poundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid = _number(_cansController) > 0 && _number(_poundsController) > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('CaféCalc')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1060),
              child: Table(
                border: TableBorder.all(color: Colors.white54, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _row(_headerCell('Unidades'), _headerCell('Detalle')),
                  _row(_inputCell(_priceController, highlighted: true),
                      _detailCell('Precio Becamo hoy PH')),
                  _row(_inputCell(_cansController),
                      _detailCell('Latas por carga', bold: true)),
                  _row(_valueCell(valid ? _format(_averagePrice) : '—'),
                      _detailCell('Precio Prom lata', bold: true)),
                  _row(_inputCell(_benefitController),
                      _detailCell('Costo Beneficiado', bold: true)),
                  _row(_valueCell(valid ? _format(_pricePerCan) : '—'),
                      _detailCell('Precio por lata a pagar', bold: true)),
                  _row(_inputCell(_poundsController),
                      _detailCell('libras por galon', bold: true)),
                  _row(_valueCell(valid ? _format(_pricePerPound) : '—'),
                      _detailCell('Precio libra a pagar', bold: true)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
