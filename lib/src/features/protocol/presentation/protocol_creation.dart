import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';
import 'package:ic_app/src/features/protocol/presentation/widget/create_protocols_widget.dart';
import 'package:ic_app/database/sensorial_vibration_db.dart';
import 'package:ic_app/src/features/protocol/presentation/run_protocol_page.dart';

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
                      separatorBuilder: (context, index) => const Divider(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                      itemCount: protocols.length,
                      itemBuilder: (context, index) {
                        final protocol = protocols[index];
                        return ListTile(
                            title: Text(
                              protocol.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "A(${protocol.amplitude}) T(${protocol.time}) t(${protocol.type}) up(${protocol.percentageUP}) down(${protocol.percentageDOWN}) reversao(${protocol.reversions})"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await sensorialVibrationDB
                                        .delete(protocol.id);
                                    fetchProtocols();
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          RunProtocolPage(protocol: protocol),
                                    ));
                                  },
                                  icon: const Icon(Icons.play_arrow,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CreateProtocolsWidget(
                                      protocol: protocol,
                                      onSubmit: (protocolData) async {
                                        await sensorialVibrationDB.update(
                                            id: protocolData.id,
                                            name: protocolData.name,
                                            amplitude: protocolData.amplitude,
                                            time: protocolData.time,
                                            type: protocolData.type,
                                            percentageUP:
                                                protocolData.percentageUP,
                                            percentageDOWN:
                                                protocolData.percentageDOWN,
                                            reversions:
                                                protocolData.reversions);
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
              builder: (_) =>
                  CreateProtocolsWidget(onSubmit: (protocolData) async {
                await sensorialVibrationDB.create(
                  name: protocolData.name,
                  amplitude: protocolData.amplitude,
                  time: protocolData.time,
                  type: protocolData.type,
                  percentageUP: protocolData.percentageUP,
                  percentageDOWN: protocolData.percentageDOWN,
                  reversions: protocolData.reversions,
                );
                if (!mounted) return;
                fetchProtocols();
                Navigator.of(context).pop();
              }),
            );
          },
        ),
      );
}
