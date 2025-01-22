import 'package:flutter/material.dart';
import 'package:ohabito/core/colors/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';

import '../../models/habit_model.dart';

class NewTaskPage extends StatelessWidget {
  NewTaskPage({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Habit',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'What\'s your habit?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff18181B),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(
                    width: 2,
                    color: AppColors.greymed,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: AppColors.greyLight),
                  decoration: InputDecoration(
                    hintText: 'study, run...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.greyLight),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
                  onPressed: () async {
                    HabitModel task = HabitModel(
                      id: const Uuid().v1(),
                      description: controller.text,
                      date: DateTime(2023, 1, 5, 14, 30, 0),
                      isFinished: false,
                    );

                    await context.read<HabitProvider>().addHabit(task);
                    Navigator.pop(context, task);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 5),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
