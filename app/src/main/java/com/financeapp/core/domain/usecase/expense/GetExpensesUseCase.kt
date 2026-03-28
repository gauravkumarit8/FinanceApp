package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class GetExpensesUseCase @Inject constructor(private val repo: ExpenseRepository) {
    operator fun invoke(s: Long, e: Long) = repo.getExpensesByDateRange(s, e)
}
