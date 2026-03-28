package com.financeapp.navigation
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.financeapp.feature.budget.ui.BudgetScreen
import com.financeapp.feature.dashboard.ui.DashboardScreen
import com.financeapp.feature.expenses.ui.AddExpenseScreen
import com.financeapp.feature.expenses.ui.ExpenseListScreen
import com.financeapp.feature.goals.ui.GoalsScreen
import com.financeapp.feature.income.ui.IncomeScreen
import com.financeapp.feature.reports.ui.ReportsScreen
import com.financeapp.feature.bills.ui.BillsScreen
import com.financeapp.feature.settings.ui.SettingsScreen
@Composable
fun AppNavGraph() {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.Dashboard.route) {
        composable(Screen.Dashboard.route)  { DashboardScreen(navController) }
        composable(Screen.Expenses.route)   { ExpenseListScreen(navController) }
        composable(Screen.AddExpense.route) { AddExpenseScreen(navController) }
        composable(Screen.Budget.route)     { BudgetScreen(navController) }
        composable(Screen.Income.route)     { IncomeScreen(navController) }
        composable(Screen.Goals.route)      { GoalsScreen(navController) }
        composable(Screen.Reports.route)    { ReportsScreen(navController) }
        composable(Screen.Bills.route)      { BillsScreen(navController) }
        composable(Screen.Settings.route)   { SettingsScreen(navController) }
    }
}
