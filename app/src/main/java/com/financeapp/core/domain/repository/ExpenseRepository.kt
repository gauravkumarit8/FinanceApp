package com.financeapp.core.domain.repository
import com.financeapp.core.data.local.dao.CategoryTotal; import com.financeapp.core.domain.model.Expense; import kotlinx.coroutines.flow.Flow
interface ExpenseRepository {
    fun getAllExpenses(): Flow<List<Expense>>
    fun getExpensesByDateRange(s: Long, e: Long): Flow<List<Expense>>
    fun getTotalForPeriod(s: Long, e: Long): Flow<Double>
    fun getCategoryTotals(s: Long, e: Long): Flow<List<CategoryTotal>>
    suspend fun addExpense(expense: Expense): Long
    suspend fun updateExpense(expense: Expense)
    suspend fun deleteExpense(expense: Expense)
}
