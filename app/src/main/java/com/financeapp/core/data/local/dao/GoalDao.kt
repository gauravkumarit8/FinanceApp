package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.GoalEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface GoalDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(g: GoalEntity): Long
    @Update suspend fun update(g: GoalEntity)
    @Delete suspend fun delete(g: GoalEntity)
    @Query("SELECT * FROM goals ORDER BY deadline ASC") fun getAllGoals(): Flow<List<GoalEntity>>
    @Query("SELECT * FROM goals WHERE id = :id LIMIT 1") suspend fun getById(id: Long): GoalEntity?
}
