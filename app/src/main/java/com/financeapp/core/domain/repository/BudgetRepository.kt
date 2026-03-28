package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Budget; import kotlinx.coroutines.flow.Flow
interface BudgetRepository {
    fun getBudgetsForMonth(month: Int, year: Int): Flow<List<Budget>>
    suspend fun addBudget(budget: Budget): Long
    suspend fun updateBudget(budget: Budget)
    suspend fun deleteBudget(budget: Budget)
}
