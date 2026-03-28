package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.IncomeEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface IncomeDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(i: IncomeEntity): Long
    @Delete suspend fun delete(i: IncomeEntity)
    @Query("SELECT * FROM incomes ORDER BY date DESC") fun getAllIncomes(): Flow<List<IncomeEntity>>
    @Query("SELECT * FROM incomes WHERE date BETWEEN :s AND :e ORDER BY date DESC") fun getByDateRange(s: Long, e: Long): Flow<List<IncomeEntity>>
    @Query("SELECT SUM(amount) FROM incomes WHERE date BETWEEN :s AND :e") fun getTotalForPeriod(s: Long, e: Long): Flow<Double?>
}
