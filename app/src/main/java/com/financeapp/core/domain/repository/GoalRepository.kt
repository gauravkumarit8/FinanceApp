package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Goal; import kotlinx.coroutines.flow.Flow
interface GoalRepository {
    fun getAllGoals(): Flow<List<Goal>>
    suspend fun addGoal(goal: Goal): Long
    suspend fun updateGoal(goal: Goal)
    suspend fun deleteGoal(goal: Goal)
    suspend fun addToGoal(goalId: Long, amount: Double)
}
