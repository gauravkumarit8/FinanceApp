package com.financeapp.navigation
sealed class Screen(val route: String) {
    object Dashboard  : Screen("dashboard")
    object Expenses   : Screen("expenses")
    object AddExpense : Screen("add_expense")
    object Budget     : Screen("budget")
    object Income     : Screen("income")
    object Goals      : Screen("goals")
    object Reports    : Screen("reports")
    object Bills      : Screen("bills")
    object Settings   : Screen("settings")
}
