package com.financeapp.core.domain.usecase.budget
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository; import javax.inject.Inject
class AddBudgetUseCase @Inject constructor(private val repo: BudgetRepository) {
    suspend operator fun invoke(budget: Budget): Result<Long> = runCatching {
        require(budget.limitAmount > 0) { "Budget limit must be greater than zero" }
        require(budget.category.isNotBlank()) { "Category cannot be empty" }
        repo.addBudget(budget)
    }
}
