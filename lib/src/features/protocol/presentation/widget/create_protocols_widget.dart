import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';

class CreateProtocolsWidget extends StatefulWidget {
  final Protocols? protocol;
  final ValueChanged<String> onSubmit;

  const CreateProtocolsWidget({
    Key? key,
    this.protocol,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateProtocolsWidget> createState() => _CreateProtocolsWidgetState();
}

class _CreateProtocolsWidgetState extends State<CreateProtocolsWidget> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.text = widget.protocol?.name ?? 'teste';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.protocol != null;
    return AlertDialog(
      title: Text(isEditing ? 'Editar Protocolo' : 'Criar Protocolo'),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Title'),
          validator: (value) =>
              value != null && value.isEmpty ? 'Titulo é necessário' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.onSubmit(controller.text);
            }
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
