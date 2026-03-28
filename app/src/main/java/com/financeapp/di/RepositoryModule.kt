package com.financeapp.di
import com.financeapp.core.data.repository.*; import com.financeapp.core.domain.repository.*
import dagger.Binds; import dagger.Module; import dagger.hilt.InstallIn; import dagger.hilt.components.SingletonComponent; import javax.inject.Singleton
@Module @InstallIn(SingletonComponent::class)
abstract class RepositoryModule {
    @Binds @Singleton abstract fun bindExpenseRepository(impl: ExpenseRepositoryImpl): ExpenseRepository
    @Binds @Singleton abstract fun bindBudgetRepository(impl: BudgetRepositoryImpl): BudgetRepository
    @Binds @Singleton abstract fun bindIncomeRepository(impl: IncomeRepositoryImpl): IncomeRepository
    @Binds @Singleton abstract fun bindGoalRepository(impl: GoalRepositoryImpl): GoalRepository
    @Binds @Singleton abstract fun bindBillRepository(impl: BillRepositoryImpl): BillRepository
}
