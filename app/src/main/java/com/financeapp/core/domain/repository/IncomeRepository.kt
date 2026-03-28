package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Income; import kotlinx.coroutines.flow.Flow
interface IncomeRepository {
    fun getAllIncomes(): Flow<List<Income>>
    fun getIncomesByDateRange(s: Long, e: Long): Flow<List<Income>>
    fun getTotalForPeriod(s: Long, e: Long): Flow<Double>
    suspend fun addIncome(income: Income): Long
    suspend fun deleteIncome(income: Income)
}
