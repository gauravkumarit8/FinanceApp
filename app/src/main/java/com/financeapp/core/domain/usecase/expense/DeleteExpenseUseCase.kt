package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class DeleteExpenseUseCase @Inject constructor(private val repo: ExpenseRepository) {
    suspend operator fun invoke(expense: Expense) = repo.deleteExpense(expense)
}
