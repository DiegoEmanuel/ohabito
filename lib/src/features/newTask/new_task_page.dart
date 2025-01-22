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
        title: const Text(
          'Novo Hábito',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Criar Hábito',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Qual é o seu hábito?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff18181B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2,
                    color: AppColors.greymed,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'estudar, correr...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.greyLight),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, digite um hábito'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    //atualzar a lista de hábitos
                    context.read<HabitProvider>().fetchHabits();
                    //voltar
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hábito adicionado com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    HabitModel task = HabitModel(
                      id: const Uuid().v1(),
                      description: controller.text,
                      date: DateTime(2023, 1, 5, 14, 30, 0),
                      isFinished: false,
                    );

                    await context.read<HabitProvider>().addHabit(task);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8),
                      Text(
                        "Salvar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
