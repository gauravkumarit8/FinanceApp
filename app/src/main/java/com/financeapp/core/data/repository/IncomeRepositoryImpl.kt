package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.IncomeDao; import com.financeapp.core.data.local.entity.IncomeEntity
import com.financeapp.core.domain.model.Income; import com.financeapp.core.domain.repository.IncomeRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class IncomeRepositoryImpl @Inject constructor(private val dao: IncomeDao) : IncomeRepository {
    override fun getAllIncomes() = dao.getAllIncomes().map { it.map { i -> i.toDomain() } }
    override fun getIncomesByDateRange(s: Long, e: Long) = dao.getByDateRange(s, e).map { it.map { i -> i.toDomain() } }
    override fun getTotalForPeriod(s: Long, e: Long) = dao.getTotalForPeriod(s, e).map { it ?: 0.0 }
    override suspend fun addIncome(income: Income) = dao.insert(income.toEntity())
    override suspend fun deleteIncome(income: Income) = dao.delete(income.toEntity())
    private fun IncomeEntity.toDomain() = Income(id, amount, source, note, date, isAutoDetected)
    private fun Income.toEntity() = IncomeEntity(id, amount, source, note, date, isAutoDetected)
}
