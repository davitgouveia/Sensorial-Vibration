import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';
import 'package:ic_app/src/features/protocol/presentation/widget/create_protocols_widget.dart';
import 'package:ic_app/database/sensorialVibration_db.dart';

class ProtocolsPage extends StatefulWidget {
  const ProtocolsPage({super.key});

  @override
  State<ProtocolsPage> createState() => _ProtocolsPageState();
}

class _ProtocolsPageState extends State<ProtocolsPage> {
  Future<List<Protocols>>? futureProtocols;
  final sensorialVibrationDB = SensorialVibrationDB();

  @override
  void initState() {
    super.initState();

    fetchProtocols();
  }

  void fetchProtocols() {
    setState(() {
      futureProtocols = sensorialVibrationDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Protocols>>(
          future: futureProtocols,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final protocols = snapshot.data!;

              return protocols.isEmpty
                  ? const Center(
                      child: Text(
                        'Sem protocolos..',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: protocols.length,
                      itemBuilder: (context, index) {
                        final protocol = protocols[index];
                        print("Protocol name: ${protocol.name}");
                        return ListTile(
                            title: Text(
                              protocol.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "A(${protocol.amplitude}) T(${protocol.time}) t(${protocol.type}) up(${protocol.percentageUP}) down(${protocol.percentageDOWN})"),
                            trailing: IconButton(
                              onPressed: () async {
                                await sensorialVibrationDB.delete(protocol.id);
                                fetchProtocols();
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CreateProtocolsWidget(
                                      protocol: protocol,
                                      onSubmit: (name) async {
                                        await sensorialVibrationDB.update(
                                            id: protocol.id,
                                            name: protocol.name);
                                        fetchProtocols();
                                        if (!mounted) return;
                                        Navigator.of(context).pop();
                                      }));
                            });
                      },
                    );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateProtocolsWidget(onSubmit: (text) async {
                await sensorialVibrationDB.create(
                    name: text,
                    //placeholder, e necessario todas essas informaçoes para inserir
                    amplitude: 128,
                    time: 1000,
                    type: 'amplitude',
                    percentageUP: 30,
                    percentageDOWN: 20);
                if (!mounted) return;
                fetchProtocols();
                Navigator.of(context).pop();
              }),
            );
          },
        ),
      );
}
