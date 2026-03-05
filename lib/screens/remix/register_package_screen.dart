import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPackageScreen extends StatefulWidget {
  const RegisterPackageScreen({super.key});

  @override
  State<RegisterPackageScreen> createState() => _RegisterPackageScreenState();
}

class _RegisterPackageScreenState extends State<RegisterPackageScreen> {
  // Steps: 0: Form, 1: Billing/Confirm, 2: Receipt
  int _currentStep = 0;

  // Form State
  String? _senderName;
  String? _receiverName;
  String _description = '';
  String _weight = '';
  String _price = '';
  String? _selectedRoute;
  String _paymentStatus = 'paid';

  // Billing Fields
  String _paymentMethod = 'EFECTIVO';
  double _amountReceived = 0.0;
  double _discount = 0.0;

  final _creditCardFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  void _nextStep() {
    if (_senderName == null || _receiverName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona remitente y destinatario')),
      );
      return;
    }
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una ruta')));
      return;
    }
    setState(() => _currentStep = 1);
  }

  void _finishRegistration() {
    setState(() => _currentStep = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentStep == 0
              ? 'Nueva Encomienda'
              : (_currentStep == 1 ? 'Confirmación' : 'Comprobante'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _currentStep < 2 ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    if (_currentStep == 0) return _buildForm();
    if (_currentStep == 1) return _buildBillingConfirm();
    return _buildReceipt();
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Remitente y Destinatario
          _buildSectionCard(
            title: 'Remitente y Destinatario',
            icon: LucideIcons.user,
            iconColor: Colors.blue[600]!,
            child: Column(
              children: [
                _buildSelectButton(
                  'Remitente',
                  _senderName,
                  () => setState(() => _senderName = 'Juan Pérez'),
                ),
                const SizedBox(height: 16),
                _buildSelectButton(
                  'Destinatario',
                  _receiverName,
                  () => setState(() => _receiverName = 'Empresa S.A.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detalles del Paquete
          _buildSectionCard(
            title: 'Detalles del Paquete',
            icon: LucideIcons.package,
            iconColor: Colors.orange[500]!,
            child: Column(
              children: [
                _buildInput(
                  label: 'Descripción',
                  hint: 'Ej. Caja de repuestos',
                  onChanged: (v) => _description = v,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        label: 'Peso (kg)',
                        hint: '0.0',
                        isNumber: true,
                        onChanged: (v) => _weight = v,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        label: 'Precio (Bs)',
                        hint: '0.00',
                        isNumber: true,
                        onChanged: (v) => _price = v,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ruta
          _buildSectionCard(
            title: 'Asignación de Ruta',
            icon: LucideIcons.map,
            iconColor: Colors.green[600]!,
            child:
                _selectedRoute == null
                    ? GestureDetector(
                      onTap:
                          () => setState(
                            () =>
                                _selectedRoute = 'Santa Cruz → La Paz | 18:30',
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.alertCircle,
                                color: Colors.blue[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No hay ruta asignada',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Toca para seleccionar una ruta',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : _buildSelectButton(
                      'Ruta Seleccionada',
                      _selectedRoute,
                      () => setState(() => _selectedRoute = null),
                    ),
          ),
          const SizedBox(height: 16),

          // Estado de Pago
          _buildSectionCard(
            title: 'Estado de Pago',
            icon: LucideIcons.dollarSign,
            iconColor: Colors.yellow[700]!,
            child: Row(
              children: [
                Expanded(
                  child: _buildPaymentOption(
                    title: 'Pagado',
                    subtitle: '(Factura)',
                    icon: LucideIcons.checkCircle,
                    isSelected: _paymentStatus == 'paid',
                    onTap: () => setState(() => _paymentStatus = 'paid'),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentOption(
                    title: 'Por Pagar',
                    subtitle: '(Voucher)',
                    icon: LucideIcons.alertCircle,
                    isSelected: _paymentStatus == 'pending',
                    onTap: () => setState(() => _paymentStatus = 'pending'),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBillingConfirm() {
    double priceNum = double.tryParse(_price) ?? 0.0;
    double total = priceNum - _discount;
    if (total < 0) total = 0;
    double change = _paymentMethod == 'EFECTIVO' ? (_amountReceived - total) : 0;
    if (change < 0) change = 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.receipt, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'Resumen de Encomienda',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    _buildSummaryRow('Remitente:', _senderName ?? ''),
                    _buildSummaryRow('Destinatario:', _receiverName ?? ''),
                    _buildSummaryRow('Ruta:', _selectedRoute ?? ''),
                    _buildSummaryRow('Descripción:', _description),
                    _buildSummaryRow(
                      'Subtotal:',
                      'Bs ${priceNum.toStringAsFixed(2)}',
                    ),
                    if (_discount > 0)
                      _buildSummaryRow(
                        'Descuento:',
                        '-Bs ${_discount.toStringAsFixed(2)}',
                        color: Colors.red
                      ),
                    const Divider(),
                    _buildSummaryRow(
                      'Total a Pagar:',
                      'Bs ${total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_paymentStatus == 'paid')
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Método de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildPaymentOptionSmall('EFECTIVO', LucideIcons.banknote),
                          const SizedBox(width: 8),
                          _buildPaymentOptionSmall('TARJETA', LucideIcons.creditCard),
                          const SizedBox(width: 8),
                          _buildPaymentOptionSmall('QR', LucideIcons.qrCode),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_paymentMethod == 'EFECTIVO') ...[
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Monto Recibido (Bs)', border: OutlineInputBorder()),
                          onChanged: (val) => setState(() => _amountReceived = double.tryParse(val) ?? 0.0),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Cambio:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Text('Bs ${change.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ]
                        )
                      ] else if (_paymentMethod == 'TARJETA') ...[
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [_creditCardFormatter],
                          decoration: const InputDecoration(labelText: 'Número de Tarjeta', hintText: '0000 0000 0000 0000', border: OutlineInputBorder()),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Descuento (Bs)', border: OutlineInputBorder()),
                        onChanged: (val) => setState(() => _discount = double.tryParse(val) ?? 0.0),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceipt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.checkCircle, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            '¡Encomienda Registrada!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'El comprobante se generó correctamente.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Volver al inicio',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? Colors.grey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 18 : 14,
              color: color ?? (isBold ? Colors.blue[600] : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionSmall(String method, IconData icon) {
    bool isSelected = _paymentMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentMethod = method),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.white,
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(height: 4),
              Text(method, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: ElevatedButton(
        onPressed: _currentStep == 0 ? _nextStep : _finishRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _currentStep == 0
              ? (_paymentStatus == 'paid'
                  ? 'CONTINUAR A FACTURACIÓN'
                  : 'GENERAR COMPROBANTE')
              : 'CONFIRMAR Y FINALIZAR',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSelectButton(String label, String? value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: value != null ? Colors.blue[50] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value != null ? Colors.blue[200]! : Colors.grey[200]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? 'Seleccionar $label',
                  style: TextStyle(
                    color: value != null ? Colors.blue[900] : Colors.grey[600],
                    fontWeight:
                        value != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: value != null ? Colors.blue[600] : Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    bool isNumber = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[400]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required MaterialColor color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color[500]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color[600] : Colors.grey, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color[700] : Colors.grey[600],
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? color[600] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
