import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';

class CreateProtocolsWidget extends StatefulWidget {
  final Protocols? protocol;
  final Function(Protocols) onSubmit;

  const CreateProtocolsWidget({
    Key? key,
    this.protocol,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateProtocolsWidget> createState() => _CreateProtocolsWidgetState();
}

class _CreateProtocolsWidgetState extends State<CreateProtocolsWidget> {
  final nameController = TextEditingController();
  final amplitudeController = TextEditingController();
  final timeController = TextEditingController();
  final typeController = TextEditingController();
  final percentageUPController = TextEditingController();
  final percentageDOWNController = TextEditingController();
  final reversionsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String selectedType = "Amplitude";

  @override
  void initState() {
    super.initState();

    if (widget.protocol != null) {
      nameController.text = widget.protocol!.name;
      amplitudeController.text = widget.protocol!.amplitude.toString();
      timeController.text = widget.protocol!.time.toString();
      selectedType = widget.protocol!.type;
      percentageUPController.text = widget.protocol!.percentageUP.toString();
      percentageDOWNController.text =
          widget.protocol!.percentageDOWN.toString();
      reversionsController.text = widget.protocol!.reversions.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.protocol != null;
    return AlertDialog(
      title: Text(isEditing ? 'Editar Protocolo' : 'Criar Protocolo'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value != null && value.isEmpty ? 'Nome é necessário' : null,
              ),
              TextFormField(
                controller: amplitudeController,
                decoration: const InputDecoration(
                    hintText: 'Digite a Amplitude (1-255)',
                    labelText: 'Amplitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1 || intValue > 255) {
                      return 'Valor tem de ser entre 1 e 255';
                    }
                  } else {
                    return 'Amplitude é necessário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Tempo (ms)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ["Amplitude", "Tempo"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue ?? "Amplitude";
                  });
                },
                decoration:
                    const InputDecoration(labelText: "Atributo manipulado"),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tipo é necessário' : null,
              ),
              // Repeat the same for other attributes
              TextFormField(
                controller: percentageUPController,
                decoration: const InputDecoration(
                    labelText: 'Incremento (%)',
                    hintText: 'Porcentagem (1-100)%'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1 || intValue > 100) {
                      return 'Valor entre 1% e 100%';
                    }
                  } else {
                    return 'Valor de incremento necessário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: percentageDOWNController,
                decoration: const InputDecoration(
                    labelText: 'Decremento (%)',
                    hintText: 'Porcentagem (1-100)%'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1 || intValue > 100) {
                      return 'Valor entre 1% e 100%';
                    }
                  } else {
                    return 'Valor de decremento necessário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: reversionsController,
                decoration: const InputDecoration(
                    labelText: 'Reversões', hintText: 'Numero 1-100'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1 || intValue > 100) {
                      return 'Valor entre 1 e 100';
                    }
                  } else {
                    return 'Quantidade de reversões necessária';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final protocolData = Protocols(
                  id: widget.protocol?.id ?? 0,
                  name: nameController.text,
                  amplitude: int.tryParse(amplitudeController.text) ?? 128,
                  time: int.tryParse(timeController.text) ?? 1000,
                  type: selectedType,
                  percentageUP: int.tryParse(percentageUPController.text) ?? 30,
                  percentageDOWN:
                      int.tryParse(percentageDOWNController.text) ?? 20,
                  reversions: int.tryParse(reversionsController.text) ?? 10);

              widget.onSubmit(protocolData);
            }
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
