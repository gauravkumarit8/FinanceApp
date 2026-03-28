package com.financeapp.di
import com.financeapp.core.domain.repository.*; import com.financeapp.core.domain.usecase.expense.*; import com.financeapp.core.domain.usecase.budget.*
import com.financeapp.core.domain.usecase.income.*; import com.financeapp.core.domain.usecase.goal.*; import com.financeapp.core.domain.usecase.bill.*
import dagger.Module; import dagger.Provides; import dagger.hilt.InstallIn; import dagger.hilt.components.SingletonComponent
@Module @InstallIn(SingletonComponent::class)
object UseCaseModule {
    @Provides fun provideAddExpenseUseCase(r: ExpenseRepository)       = AddExpenseUseCase(r)
    @Provides fun provideGetExpensesUseCase(r: ExpenseRepository)      = GetExpensesUseCase(r)
    @Provides fun provideDeleteExpenseUseCase(r: ExpenseRepository)    = DeleteExpenseUseCase(r)
    @Provides fun provideGetCategoryTotalsUseCase(r: ExpenseRepository)= GetCategoryTotalsUseCase(r)
    @Provides fun provideAddBudgetUseCase(r: BudgetRepository)         = AddBudgetUseCase(r)
    @Provides fun provideGetBudgetStatusUseCase(r: BudgetRepository)   = GetBudgetStatusUseCase(r)
    @Provides fun provideAddIncomeUseCase(r: IncomeRepository)         = AddIncomeUseCase(r)
    @Provides fun provideGetIncomesUseCase(r: IncomeRepository)        = GetIncomesUseCase(r)
    @Provides fun provideAddGoalUseCase(r: GoalRepository)             = AddGoalUseCase(r)
    @Provides fun provideGetGoalsUseCase(r: GoalRepository)            = GetGoalsUseCase(r)
    @Provides fun provideAddBillUseCase(r: BillRepository)             = AddBillUseCase(r)
    @Provides fun provideGetBillsUseCase(r: BillRepository)            = GetBillsUseCase(r)
}
