import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const CafeCalcApp());

const _background = Color(0xFF080D09);
const _green = Color(0xFF39FF88);
const _amber = Color(0xFFFFB74D);
const _muted = Color(0xFFC4D2CA);

class CafeCalcApp extends StatelessWidget {
  const CafeCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaféCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: _background,
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final _price = TextEditingController(text: '10000.00');
  final _cans = TextEditingController(text: '32');
  final _cost = TextEditingController(text: '15');
  final _pounds = TextEditingController(text: '30');

  double _number(TextEditingController controller) {
    return double.tryParse(controller.text.trim().replaceAll(',', '.')) ?? 0;
  }

  String _format(double value) =>
      value.isFinite ? value.toStringAsFixed(2) : '—';

  @override
  void dispose() {
    _price.dispose();
    _cans.dispose();
    _cost.dispose();
    _pounds.dispose();
    super.dispose();
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool highlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1B15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlighted ? _green : const Color(0xFF214333),
          ),
          boxShadow: [
            if (highlighted)
              const BoxShadow(color: Color(0x5539FF88), blurRadius: 14),
          ],
        ),
        child: Semantics(
          label: label,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            cursorColor: _green,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 12, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1,
                  child: Text(
                    label,
                    style: const TextStyle(color: _muted, fontSize: 14),
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minHeight: 54),
              contentPadding: const EdgeInsets.fromLTRB(0, 14, 18, 14),
              border: InputBorder.none,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cans = _number(_cans);
    final pounds = _number(_pounds);
    final valid = cans > 0 && pounds > 0;
    final average = _number(_price) / cans;
    final perCan = average - _number(_cost);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 46, 20, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'CaféCalc',
                    style: TextStyle(
                      color: _green,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: _green, blurRadius: 13)],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CustomPaint(
                      painter: const _RingPainter(),
                      child: SizedBox.square(
                        dimension: 220,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Precio libra a pagar',
                                style: TextStyle(color: _muted, fontSize: 14),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  valid ? _format(perCan / pounds) : '—',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    height: 1.08,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(color: _green, blurRadius: 22),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _input('Precio Becamo hoy PH', _price, highlighted: true),
                  _input('Latas por carga', _cans),
                  _input('Costo Beneficiado', _cost),
                  _input('Libras por galón', _pounds),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _ResultCard(
                            label: 'Precio Prom lata',
                            value: valid ? _format(average) : '—',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ResultCard(
                            label: 'Precio por lata a pagar',
                            value: valid ? _format(perCan) : '—',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1408),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD79C48)),
        boxShadow: const [BoxShadow(color: Color(0x40FFB74D), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFE7D5B8), fontSize: 13),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: _amber,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                shadows: [Shadow(color: _amber, blurRadius: 14)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ring = (Offset.zero & size).deflate(10);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    const start = -math.pi / 2;
    const sweep = 2 * math.pi - 0.30;
    canvas.drawArc(
      ring,
      start,
      sweep,
      false,
      stroke
        ..color = _green
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.drawArc(ring, start, sweep, false, stroke..maskFilter = null);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}
