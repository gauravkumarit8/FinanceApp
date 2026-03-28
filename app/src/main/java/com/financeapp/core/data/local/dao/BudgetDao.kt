package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.BudgetEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface BudgetDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(b: BudgetEntity): Long
    @Update suspend fun update(b: BudgetEntity)
    @Delete suspend fun delete(b: BudgetEntity)
    @Query("SELECT * FROM budgets WHERE month = :month AND year = :year") fun getBudgetsForMonth(month: Int, year: Int): Flow<List<BudgetEntity>>
    @Query("SELECT * FROM budgets WHERE category = :cat AND month = :month AND year = :year LIMIT 1") suspend fun getBudgetForCategory(cat: String, month: Int, year: Int): BudgetEntity?
}
