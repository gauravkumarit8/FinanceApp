package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.ExpenseEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface ExpenseDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(e: ExpenseEntity): Long
    @Update suspend fun update(e: ExpenseEntity)
    @Delete suspend fun delete(e: ExpenseEntity)
    @Query("SELECT * FROM expenses ORDER BY date DESC") fun getAllExpenses(): Flow<List<ExpenseEntity>>
    @Query("SELECT * FROM expenses WHERE date BETWEEN :s AND :e ORDER BY date DESC") fun getByDateRange(s: Long, e: Long): Flow<List<ExpenseEntity>>
    @Query("SELECT SUM(amount) FROM expenses WHERE date BETWEEN :s AND :e") fun getTotalForPeriod(s: Long, e: Long): Flow<Double?>
    @Query("SELECT category, SUM(amount) as total FROM expenses WHERE date BETWEEN :s AND :e GROUP BY category ORDER BY total DESC") fun getCategoryTotals(s: Long, e: Long): Flow<List<CategoryTotal>>
}
data class CategoryTotal(val category: String, val total: Double)
