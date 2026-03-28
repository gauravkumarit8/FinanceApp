package com.financeapp.core.domain.usecase.income
import com.financeapp.core.domain.model.Income; import com.financeapp.core.domain.repository.IncomeRepository; import javax.inject.Inject
class AddIncomeUseCase @Inject constructor(private val repo: IncomeRepository) {
    suspend operator fun invoke(income: Income): Result<Long> = runCatching {
        require(income.amount > 0) { "Amount must be greater than zero" }
        require(income.source.isNotBlank()) { "Source cannot be empty" }
        repo.addIncome(income)
    }
}
