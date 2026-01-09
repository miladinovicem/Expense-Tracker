import 'expense_service.dart';
import 'income_service.dart';

class BalanceService {
  final ExpenseService _expenseService = ExpenseService();
  final IncomeService _incomeService = IncomeService();

  Future<double> getTotalExpenses() async {
    final expenses = await _expenseService.getExpenses();

    return expenses.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );
  }

  Future<double> getTotalIncome() async {
    final incomes = await _incomeService.getIncomes();

    return incomes.fold<double>(
      0.0,
      (sum, i) => sum + i.amount,
    );
  }

  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();

    return income - expenses;
  }
}
