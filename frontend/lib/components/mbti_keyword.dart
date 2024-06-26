import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';

class MbtiKeyWord extends GetView<KeywordController> {
  final Function(String) onMbtiSelected;
  final String title;

  MbtiKeyWord({required this.title, required this.onMbtiSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 내향적 vs 외향적
            const Text('내향적 vs 외향적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            Obx(() => ToggleButtons(
                  onPressed: (int index) {
                    controller.selectMBTI(index, 'IE');
                    onMbtiSelected(controller.mbti);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: blueColor3,
                  selectedColor: Colors.white,
                  fillColor: blueColor4,
                  color: blueColor1,
                  constraints: const BoxConstraints(
                    minHeight: 60.0,
                    minWidth: 160.0,
                  ),
                  isSelected: controller.selectedIE.toList(),
                  children: const [
                    Text('I', style: TextStyle(fontSize: 20)),
                    Text('E', style: TextStyle(fontSize: 20)),
                  ],
                )),
            const SizedBox(height: 10),
            // 비현실적 vs 현실적
            const Text('비현실적 vs 현실적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            Obx(() => ToggleButtons(
                  onPressed: (int index) {
                    controller.selectMBTI(index, 'NS');
                    onMbtiSelected(controller.mbti);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: blueColor3,
                  selectedColor: Colors.white,
                  fillColor: blueColor4,
                  color: blueColor1,
                  constraints: const BoxConstraints(
                    minHeight: 60.0,
                    minWidth: 160.0,
                  ),
                  isSelected: controller.selectedNS.toList(),
                  children: const [
                    Text('N', style: TextStyle(fontSize: 20)),
                    Text('S', style: TextStyle(fontSize: 20)),
                  ],
                )),
            const SizedBox(height: 10),
            // 공감적 vs 비공감적
            const Text('공감적 vs 비공감적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            Obx(() => ToggleButtons(
                  onPressed: (int index) {
                    controller.selectMBTI(index, 'FT');
                    onMbtiSelected(controller.mbti);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: blueColor3,
                  selectedColor: Colors.white,
                  fillColor: blueColor4,
                  color: blueColor1,
                  constraints: const BoxConstraints(
                    minHeight: 60.0,
                    minWidth: 160.0,
                  ),
                  isSelected: controller.selectedFT.toList(),
                  children: const [
                    Text('F', style: TextStyle(fontSize: 20)),
                    Text('T', style: TextStyle(fontSize: 20)),
                  ],
                )),
            const SizedBox(height: 10),
            // 즉흥적 vs 계획적
            const Text('즉흥적 vs 계획적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            Obx(() => ToggleButtons(
                  onPressed: (int index) {
                    controller.selectMBTI(index, 'PJ');
                    onMbtiSelected(controller.mbti);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: blueColor3,
                  selectedColor: Colors.white,
                  fillColor: blueColor4,
                  color: blueColor1,
                  constraints: const BoxConstraints(
                    minHeight: 60.0,
                    minWidth: 160.0,
                  ),
                  isSelected: controller.selectedPJ.toList(),
                  children: const [
                    Text('P', style: TextStyle(fontSize: 20)),
                    Text('J', style: TextStyle(fontSize: 20)),
                  ],
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
