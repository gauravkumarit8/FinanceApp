package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.BillEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface BillDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(b: BillEntity): Long
    @Update suspend fun update(b: BillEntity)
    @Delete suspend fun delete(b: BillEntity)
    @Query("SELECT * FROM bills ORDER BY dueDayOfMonth ASC") fun getAllBills(): Flow<List<BillEntity>>
    @Query("SELECT * FROM bills WHERE isPaid = 0 ORDER BY dueDayOfMonth ASC") fun getUnpaidBills(): Flow<List<BillEntity>>
    @Query("SELECT SUM(amount) FROM bills WHERE isRecurring = 1") fun getTotalMonthlyCommitments(): Flow<Double?>
}
