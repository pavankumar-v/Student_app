import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SampleCard extends StatefulWidget {
  const SampleCard({Key? key}) : super(key: key);

  @override
  State<SampleCard> createState() => _SampleCardState();
}

class _SampleCardState extends State<SampleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //first column element
          Row(
            children: [
              'Internet Of Things'.text.bold.xl.make(),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          //end of 1st column elment

          //2nd element
          '18CS81'.text.lg.make(),

          //3rd element
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: ['28/30'.text.make()],
          )
        ],
      ).p(14),
    ).card.rounded.elevation(15).color(Theme.of(context).canvasColor).make();
  }
}
