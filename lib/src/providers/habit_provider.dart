import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/month_model.dart';

class HabitProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HabitModel> _habits = [];
  MonthModel? _currentMonth;
  bool _isLoading = false;

  List<HabitModel> get habits => _habits;
  MonthModel? get currentMonth => _currentMonth;
  bool get isLoading => _isLoading;

  void setCurrentMonth(MonthModel month) {
    _currentMonth = month;
    notifyListeners();
  }

  Future<void> fetchHabits() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      var snapshot = await _firestore.collection('ohabito').get();
      _habits = snapshot.docs.map((doc) => HabitModel.fromMap(doc.data())).toList();

      if (_currentMonth != null) {
        _currentMonth!.list =
            _habits.where((habit) => habit.date.month == _currentMonth!.id).toList();
      }
    } catch (e) {
      print('Erro ao buscar hábitos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(HabitModel habit) async {
    try {
      await _firestore.collection('ohabito').doc(habit.id).set(habit.toMap());
      _habits.add(habit);
      if (_currentMonth != null && habit.date.month == _currentMonth!.id) {
        _currentMonth!.list.add(habit);
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar hábito: $e');
    }
  }

  Future<void> updateHabit(HabitModel habit) async {
    try {
      await _firestore.collection('ohabito').doc(habit.id).update(habit.toMap());
      int index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        if (_currentMonth != null) {
          int monthIndex = _currentMonth!.list.indexWhere((h) => h.id == habit.id);
          if (monthIndex != -1) {
            _currentMonth!.list[monthIndex] = habit;
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar hábito: $e');
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _firestore.collection('ohabito').doc(habitId).delete();
      _habits.removeWhere((habit) => habit.id == habitId);

      if (_currentMonth != null) {
        _currentMonth!.list.removeWhere((habit) => habit.id == habitId);
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao deletar hábito: $e');
      throw Exception('Falha ao excluir hábito');
    }
  }

  List<HabitModel> getDayHabits(int day, int month) {
    return _habits.where((habit) => habit.date.day == day && habit.date.month == month).toList();
  }
}
