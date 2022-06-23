import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/reusable_widget/sampleCard.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';

class PlacementsView extends StatefulWidget {
  const PlacementsView({Key? key}) : super(key: key);

  @override
  State<PlacementsView> createState() => _PlacementViewState();
}

class _PlacementViewState extends State<PlacementsView> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: const Text('Placements')),
      body: SingleChildScrollView(
        child: Column(
          children: const [SampleCard()],
        ),
      ).pLTRB(18, 0, 18, 0),
    );
  }
}
