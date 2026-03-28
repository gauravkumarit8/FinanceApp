package com.financeapp.di
import android.content.Context; import androidx.room.Room; import com.financeapp.core.data.local.dao.*; import com.financeapp.core.data.local.database.FinanceDatabase
import dagger.Module; import dagger.Provides; import dagger.hilt.InstallIn; import dagger.hilt.android.qualifiers.ApplicationContext; import dagger.hilt.components.SingletonComponent; import javax.inject.Singleton
@Module @InstallIn(SingletonComponent::class)
object DatabaseModule {
    @Provides @Singleton
    fun provideDatabase(@ApplicationContext context: Context): FinanceDatabase =
        Room.databaseBuilder(context, FinanceDatabase::class.java, FinanceDatabase.DATABASE_NAME).fallbackToDestructiveMigration().build()
    @Provides fun provideExpenseDao(db: FinanceDatabase): ExpenseDao = db.expenseDao()
    @Provides fun provideBudgetDao(db: FinanceDatabase): BudgetDao   = db.budgetDao()
    @Provides fun provideIncomeDao(db: FinanceDatabase): IncomeDao   = db.incomeDao()
    @Provides fun provideGoalDao(db: FinanceDatabase): GoalDao       = db.goalDao()
    @Provides fun provideBillDao(db: FinanceDatabase): BillDao       = db.billDao()
}
