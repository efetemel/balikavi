import 'package:flutter/material.dart';

import '../controllers/MainController.dart';
import '../utils/AppUtils.dart';

class FishView extends StatelessWidget {
  const FishView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppUtils.getMenu(),
      ),
    );
  }
}
