package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class AddExpenseUseCase @Inject constructor(private val repo: ExpenseRepository) {
    suspend operator fun invoke(expense: Expense): Result<Long> = runCatching {
        require(expense.amount > 0) { "Amount must be greater than zero" }
        require(expense.category.isNotBlank()) { "Category cannot be empty" }
        require(expense.merchant.isNotBlank()) { "Merchant cannot be empty" }
        repo.addExpense(expense)
    }
}
