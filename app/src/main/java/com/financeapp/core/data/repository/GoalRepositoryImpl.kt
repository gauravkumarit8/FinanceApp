package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.GoalDao; import com.financeapp.core.data.local.entity.GoalEntity
import com.financeapp.core.domain.model.Goal; import com.financeapp.core.domain.repository.GoalRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class GoalRepositoryImpl @Inject constructor(private val dao: GoalDao) : GoalRepository {
    override fun getAllGoals() = dao.getAllGoals().map { it.map { g -> g.toDomain() } }
    override suspend fun addGoal(goal: Goal) = dao.insert(goal.toEntity())
    override suspend fun updateGoal(goal: Goal) = dao.update(goal.toEntity())
    override suspend fun deleteGoal(goal: Goal) = dao.delete(goal.toEntity())
    override suspend fun addToGoal(goalId: Long, amount: Double) {
        val entity = dao.getById(goalId) ?: return
        dao.update(entity.copy(savedAmount = entity.savedAmount + amount))
    }
    private fun GoalEntity.toDomain() = Goal(id, name, targetAmount, savedAmount, deadline, emoji)
    private fun Goal.toEntity() = GoalEntity(id, name, targetAmount, savedAmount, deadline, emoji)
}
