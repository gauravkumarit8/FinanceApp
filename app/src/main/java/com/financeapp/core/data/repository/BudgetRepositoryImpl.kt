package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.BudgetDao; import com.financeapp.core.data.local.entity.BudgetEntity
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class BudgetRepositoryImpl @Inject constructor(private val dao: BudgetDao) : BudgetRepository {
    override fun getBudgetsForMonth(month: Int, year: Int) = dao.getBudgetsForMonth(month, year).map { it.map { b -> b.toDomain() } }
    override suspend fun addBudget(budget: Budget) = dao.insert(budget.toEntity())
    override suspend fun updateBudget(budget: Budget) = dao.update(budget.toEntity())
    override suspend fun deleteBudget(budget: Budget) = dao.delete(budget.toEntity())
    private fun BudgetEntity.toDomain() = Budget(id, category, limitAmount, 0.0, month, year)
    private fun Budget.toEntity() = BudgetEntity(id, category, limitAmount, month, year)
}
