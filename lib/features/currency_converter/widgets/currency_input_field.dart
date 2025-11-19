import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInputField extends StatelessWidget {
  final String currencyCode;
  final String value;
  final ValueChanged<String> onChanged;
  final bool isLoading;

  const CurrencyInputField({
    super.key,
    required this.currencyCode,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Using a controller to keep cursor position if possible,
    // but for simplicity in this architecture, we rely on the parent passing the value.
    // To avoid cursor jumping issues with simple state management,
    // we use a Key to ensure the widget doesn't rebuild unnecessarily,
    // OR we accept that for this demo, simple binding is okay.
    // A better approach for production is to manage TextEditingController inside the widget
    // and sync it only when external value changes significantly.

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currencyCode,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatelessTextField(
                value: value,
                onChanged: onChanged,
                enabled: !isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatelessTextField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const _StatelessTextField({
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<_StatelessTextField> createState() => _StatelessTextFieldState();
}

class _StatelessTextFieldState extends State<_StatelessTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_StatelessTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      // Only update if the value is different to avoid cursor jumping
      // when the user is typing.
      // However, if the user is typing, the parent updates the state,
      // and passes it back. If we are the source of the change,
      // widget.value should match _controller.text (mostly).
      // The issue arises when OTHER fields update THIS field.

      // Simple heuristic: if the widget is focused, don't force update
      // unless it's drastically different (which shouldn't happen if we type).
      // But here, we are just a dumb field.

      // If the text field is not focused, we definitely update.
      // If it IS focused, we assume the user is typing, so we might skip
      // unless the value is completely different (e.g. cleared).

      // For this specific requirement (4 fields updating each other),
      // when I type in USD, USD field is focused. TRY field is NOT focused.
      // TRY field should update. USD field should NOT be overwritten by the parent
      // (or if it is, it should match what I typed).

      if (!FocusScope.of(context).hasFocus) {
        _controller.text = widget.value;
      } else {
        // If we have focus, check if the values match.
        // If they don't, it means the model changed it (maybe formatting?).
        // For now, let's trust the controller's current text if focused.
        if (_controller.text != widget.value) {
          // This happens if another field updated us, but we have focus?
          // Impossible in single-user scenario unless we have focus but are not typing?
          // Or if we just switched focus.

          // Let's just update it if it's not the active driver.
          // But we don't know if we are the active driver here easily.
          // The ViewModel handles active currency.

          // Workaround: Just update it. Cursor might jump.
          // To fix cursor:
          final selection = _controller.selection;
          _controller.text = widget.value;
          // Try to restore cursor end
          if (selection.baseOffset <= widget.value.length) {
            _controller.selection = selection;
          } else {
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.value.length),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '0.00',
        filled: false,
      ),
      style: const TextStyle(fontSize: 24),
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
    );
  }
}
