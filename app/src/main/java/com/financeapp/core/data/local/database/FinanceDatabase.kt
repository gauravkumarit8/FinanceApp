package com.financeapp.core.data.local.database
import androidx.room.Database; import androidx.room.RoomDatabase
import com.financeapp.core.data.local.dao.*
import com.financeapp.core.data.local.entity.*
@Database(entities = [ExpenseEntity::class, BudgetEntity::class, IncomeEntity::class, GoalEntity::class, BillEntity::class], version = 1, exportSchema = true)
abstract class FinanceDatabase : RoomDatabase() {
    abstract fun expenseDao(): ExpenseDao
    abstract fun budgetDao(): BudgetDao
    abstract fun incomeDao(): IncomeDao
    abstract fun goalDao(): GoalDao
    abstract fun billDao(): BillDao
    companion object { const val DATABASE_NAME = "finance_db" }
}
