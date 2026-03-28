package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.CategoryTotal; import com.financeapp.core.data.local.dao.ExpenseDao; import com.financeapp.core.data.local.entity.ExpenseEntity
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class ExpenseRepositoryImpl @Inject constructor(private val dao: ExpenseDao) : ExpenseRepository {
    override fun getAllExpenses() = dao.getAllExpenses().map { it.map { e -> e.toDomain() } }
    override fun getExpensesByDateRange(s: Long, e: Long) = dao.getByDateRange(s, e).map { it.map { x -> x.toDomain() } }
    override fun getTotalForPeriod(s: Long, e: Long) = dao.getTotalForPeriod(s, e).map { it ?: 0.0 }
    override fun getCategoryTotals(s: Long, e: Long) = dao.getCategoryTotals(s, e)
    override suspend fun addExpense(expense: Expense) = dao.insert(expense.toEntity())
    override suspend fun updateExpense(expense: Expense) = dao.update(expense.toEntity())
    override suspend fun deleteExpense(expense: Expense) = dao.delete(expense.toEntity())
    private fun ExpenseEntity.toDomain() = Expense(id, amount, category, merchant, note, date, isAutoDetected, accountLast4)
    private fun Expense.toEntity() = ExpenseEntity(id, amount, category, merchant, note, date, isAutoDetected, accountLast4)
}
